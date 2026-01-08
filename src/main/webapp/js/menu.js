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
    fetch(`${CONTEXT_PATH}/notificacion/marcarLeido`, {
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
      console.log('Fetching notifications from:', `${CONTEXT_PATH}/notificaciones`);
      
      fetch(`${CONTEXT_PATH}/notificaciones`)
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
              div.innerHTML = `
                <img src="${n.origen.avatar}" class="notif-avatar" alt="${n.origen.username}">
                <div style="flex:1">
                  <strong>${n.origen.username}</strong>
                  <div style="font-size:13px;color:#555">${n.tipo}</div>
                </div>
                <div style="margin-left:8px">${n.leido ? '' : '<span class="notif-unread" style="color:#e13b63">●</span>'}</div>
              `;
              if (!n.leido) {
                div.style.cursor = 'pointer';
                div.addEventListener('click', (e) => {
                  e.stopPropagation();
                  markAsRead(n.id, div);
                });
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
    fetch(`${CONTEXT_PATH}/notificaciones`)
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
