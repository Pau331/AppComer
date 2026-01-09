// Sistema de notificaciones global sin "localhost dice..."
function mostrarNotificacion(mensaje, tipo = 'info') {
  const notif = document.createElement('div');
  notif.className = `notificacion notif-${tipo}`;
  notif.textContent = mensaje;
  notif.style.cssText = `
    position: fixed;
    top: 90px;
    right: 20px;
    background: ${tipo === 'error' ? '#e13b63' : tipo === 'success' ? '#1f8b4c' : '#333'};
    color: white;
    padding: 16px 24px;
    border-radius: 8px;
    box-shadow: 0 4px 12px rgba(0,0,0,0.15);
    z-index: 10000;
    font-weight: 600;
    max-width: 400px;
    animation: slideIn 0.3s ease;
  `;
  document.body.appendChild(notif);
  
  setTimeout(() => {
    notif.style.animation = 'slideOut 0.3s ease';
    setTimeout(() => notif.remove(), 300);
  }, 3000);
}

// Agregar animaciones CSS si no existen
if (!document.getElementById('notif-animations')) {
  const style = document.createElement('style');
  style.id = 'notif-animations';
  style.textContent = `
    @keyframes slideIn {
      from { transform: translateX(400px); opacity: 0; }
      to { transform: translateX(0); opacity: 1; }
    }
    @keyframes slideOut {
      from { transform: translateX(0); opacity: 1; }
      to { transform: translateX(400px); opacity: 0; }
    }
  `;
  document.head.appendChild(style);
}

// Sobrescribir el alert global para evitar "localhost dice..."
window.alert = function(mensaje) {
  mostrarNotificacion(mensaje, 'info');
};
