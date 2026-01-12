/* ============================
   MENÚ NOTIFICACIONES
   ============================ */

document.addEventListener('DOMContentLoaded', () => {
  const notifWrapper = document.getElementById('notif-wrapper');
  const notifDropdown = document.getElementById('notif-dropdown-sidebar');
  const notifBadge = document.getElementById('notif-badge');

  if (!notifWrapper || !notifDropdown) {
    console.warn('Notification elements not found');
    return;
  }

  console.log('Notification system loaded');

  // Función para marcar como leída
  const markAsRead = (id, element) => {
    fetch(`${CONTEXT_PATH}/notificaciones/marcarLeido`, {
      method: 'POST',
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: `id=${encodeURIComponent(id)}`
    })
    .then(r => r.json())
    .then(resp => {
      if (resp && resp.ok) {
        // actualizar badge
        if (notifBadge) {
          const nuevo = Math.max(0, resp.restantes);
          notifBadge.textContent = nuevo;
          if (nuevo === 0) notifBadge.style.display = 'none';
        }
        // marcar visualmente
        const dot = element.querySelector('.notif-unread');
        if (dot) dot.remove();
      }
    })
    .catch(err => {
      console.error('Error marcando como leído:', err);
    });
  };

  // Abrir / cerrar dropdown
  notifWrapper.addEventListener('click', e => {
    e.stopPropagation();
    console.log('Notif button clicked');
    
    // Si abrimos, cargamos notificaciones desde el servidor
    if (notifDropdown.style.display !== 'block') {
      console.log('Fetching notifications from:', `${CONTEXT_PATH}/social/notificaciones`);
      
      fetch(`${CONTEXT_PATH}/social/notificaciones`)
        .then(r => {
          console.log('Fetch response status:', r.status);
          if (!r.ok) {
            console.error('Fetch notificaciones failed, status:', r.status);
            throw new Error('HTTP ' + r.status);
          }
          return r.json();
        })
        .then(list => {
          console.log('Notifications received:', list);
          notifDropdown.innerHTML = '';
          if (!list || list.length === 0) {
            notifDropdown.innerHTML = '<p>No hay notificaciones.</p>';
          } else {
            list.forEach(n => {
              const div = document.createElement('div');
              div.className = 'notif-item';
              div.dataset.id = n.id;
              
              // Verificar si es una solicitud de amistad
              const esSolicitudAmistad = n.tipo === 'Solicitud de amistad';
              const esRecetaEliminada = n.tipo === 'Receta eliminada';
              const esComentarioEliminado = n.tipo === 'Comentario eliminado';
              const esNotificacionSistema = !n.origen || !n.origen.username;
              
              // Formatear el mensaje según el tipo
              let mensajeTipo = n.tipo;
              if (n.tipo === 'Eres amigo de...') {
                mensajeTipo = `Eres amigo de ${n.origen.username}`;
              } else if (esRecetaEliminada && n.mensaje) {
                mensajeTipo = n.mensaje;
              } else if (esComentarioEliminado && n.mensaje) {
                mensajeTipo = n.mensaje;
              }
              
              // Icono/Avatar según tipo de notificación
              let avatarHTML = '';
              if (esNotificacionSistema || esRecetaEliminada || esComentarioEliminado) {
                // Icono para notificaciones del sistema
                avatarHTML = `<div class="notif-icon-system" style="width:40px;height:40px;border-radius:50%;background:linear-gradient(135deg,#dc3545,#c82333);display:flex;align-items:center;justify-content:center;font-size:20px;flex-shrink:0;padding-bottom:8px;">⚠️</div>`;
              } else {
                // Foto de usuario para notificaciones normales
                avatarHTML = `<img src="${n.origen.avatar}" class="notif-avatar" alt="${n.origen.username}">`;
              }
              
              div.innerHTML = `
                ${avatarHTML}
                <div style="flex:1">
                  ${esRecetaEliminada || esComentarioEliminado ? 
                    `<div style="color:#dc3545;font-weight:600;font-size:13px;">
                        ${esRecetaEliminada ? 'Receta eliminada' : 'Comentario eliminado'}
                     </div>
                     <div style="font-size:13px;color:#555">${mensajeTipo}</div>` 
                    : 
                    `<strong>${n.origen.username}</strong>
                     <div style="font-size:13px;color:#555">${mensajeTipo}</div>`
                  }
                  ${esSolicitudAmistad ? `
                    <div class="notif-actions" style="display:flex;gap:8px;margin-top:8px;">
                      <button class="btn-aceptar-solicitud" data-user-id="${n.origen.id}" 
                              style="background:#28a745;color:white;border:none;padding:6px 12px;border-radius:4px;cursor:pointer;font-size:12px;font-weight:600;">
                        Aceptar
                      </button>
                      <button class="btn-rechazar-solicitud" data-user-id="${n.origen.id}"
                              style="background:#dc3545;color:white;border:none;padding:6px 12px;border-radius:4px;cursor:pointer;font-size:12px;font-weight:600;">
                        Rechazar
                      </button>
                    </div>
                  ` : ''}
                </div>
                <div style="margin-left:8px">${n.leido ? '' : '<span class="notif-unread" style="color:#e13b63">●</span>'}</div>
              `;
              
              // Marcar como leída al hacer click (solo si no es solicitud de amistad o si ya fue leída)
              if (!n.leido && !esSolicitudAmistad) {
                div.style.cursor = 'pointer';
                div.addEventListener('click', (e) => {
                  e.stopPropagation();
                  markAsRead(n.id, div);
                });
              }
              
              // Handlers para botones de solicitud
              if (esSolicitudAmistad) {
                const btnAceptar = div.querySelector('.btn-aceptar-solicitud');
                const btnRechazar = div.querySelector('.btn-rechazar-solicitud');
                
                if (btnAceptar) {
                  btnAceptar.addEventListener('click', (e) => {
                    e.stopPropagation();
                    const userId = e.target.dataset.userId;
                    
                    // Enviar solicitud de aceptación
                    fetch(`${CONTEXT_PATH}/social/aceptarSolicitud`, {
                      method: 'POST',
                      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                      body: `id=${userId}`
                    })
                    .then(r => {
                      if (r.ok) {
                        // Marcar notificación como leída y eliminar del dropdown
                        markAsRead(n.id, div);
                        div.remove();
                        mostrarNotificacion('¡Solicitud aceptada!', 'success');
                      } else {
                        mostrarNotificacion('Error al aceptar solicitud', 'error');
                      }
                    })
                    .catch(err => {
                      console.error('Error aceptando solicitud:', err);
                      mostrarNotificacion('Error al aceptar solicitud', 'error');
                    });
                  });
                }
                
                if (btnRechazar) {
                  btnRechazar.addEventListener('click', (e) => {
                    e.stopPropagation();
                    const userId = e.target.dataset.userId;
                    
                    // Enviar solicitud de rechazo (usa toggleAmigo para eliminar)
                    fetch(`${CONTEXT_PATH}/social/solicitarAmistad`, {
                      method: 'POST',
                      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                      body: `id=${userId}`
                    })
                    .then(r => {
                      if (r.ok) {
                        // Marcar notificación como leída y eliminar del dropdown
                        markAsRead(n.id, div);
                        div.remove();
                        mostrarNotificacion('Solicitud rechazada', 'info');
                      } else {
                        mostrarNotificacion('Error al rechazar solicitud', 'error');
                      }
                    })
                    .catch(err => {
                      console.error('Error rechazando solicitud:', err);
                      mostrarNotificacion('Error al rechazar solicitud', 'error');
                    });
                  });
                }
              }
              
              notifDropdown.appendChild(div);
            });
          }
          notifDropdown.style.display = 'block';
        })
        .catch(err => {
          console.error('Error cargando notificaciones:', err);
          notifDropdown.innerHTML = '<p>Error cargando notificaciones.</p>';
          notifDropdown.style.display = 'block';
        });
    } else {
      notifDropdown.style.display = 'none';
    }
  });

  // Cerrar al hacer click fuera
  document.addEventListener('click', e => {
    if (!notifWrapper.contains(e.target) &&
        !notifDropdown.contains(e.target)) {
      notifDropdown.style.display = 'none';
    }
  });

  // Al cargar la página, actualizar el contador de notificaciones
  if (notifBadge) {
    fetch(`${CONTEXT_PATH}/social/notificaciones`)
      .then(r => r.json())
      .then(list => {
        if (!list) return;
        const noLeidas = list.filter(n => !n.leido).length;
        notifBadge.textContent = noLeidas;
        notifBadge.style.display = noLeidas > 0 ? 'inline-block' : 'none';
        console.log('Badge updated with', noLeidas, 'unread notifications');
      })
      .catch(err => {
        console.warn('No se pudo actualizar contador de notificaciones:', err);
      });
  }
});

// Cerrar al hacer click fuera
document.addEventListener('click', e => {
  if (!notifWrapper?.contains(e.target) &&
      !notifDropdown?.contains(e.target)) {
    notifDropdown.style.display = 'none';
  }
});
