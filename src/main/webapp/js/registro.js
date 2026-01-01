document.addEventListener("DOMContentLoaded", () => {
  const form = document.getElementById("formRegistro");
  const btn = document.getElementById("btnRegistrar");

  // MANTENER: Efecto hover del botón (es puramente visual)
  btn.addEventListener("mouseover", () => (btn.style.backgroundColor = "#c12c54"));
  btn.addEventListener("mouseout", () => (btn.style.backgroundColor = "#e13b63"));

  // MODIFICAR: Validación y envío
  form.addEventListener("submit", (e) => {
    
    const nombre = document.getElementById("nombre").value.trim();
    const email = document.getElementById("email").value.trim();
    const pass = document.getElementById("password").value;
    const conf = document.getElementById("confirmar").value;

    // VALIDACIÓN CLIENTE: Si algo falla, detenemos el envío
    if (!nombre || !email || !pass || !conf) {
      e.preventDefault(); // Detenemos el envío al Servlet
      alert("Por favor, completa todos los campos.");
      return;
    }

    const correoValido = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
    if (!correoValido) {
      e.preventDefault(); // Detenemos el envío al Servlet
      alert("Por favor, introduce un correo electrónico válido.");
      return;
    }

    if (pass !== conf) {
      e.preventDefault(); // Detenemos el envío al Servlet
      alert("Las contraseñas no coinciden.");
      return;
    }

    // SI LLEGA AQUÍ: No hay e.preventDefault(), por lo que 
    // el navegador enviará automáticamente los datos a tu Servlet.
    console.log("Datos validados en cliente. Enviando al servidor...");
  });
});