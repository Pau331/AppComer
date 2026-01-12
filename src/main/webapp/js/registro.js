document.addEventListener("DOMContentLoaded", () => {
  const form = document.getElementById("formRegistro");
  const btn = document.getElementById("btnRegistrar");

 
  btn.addEventListener("mouseover", () => (btn.style.backgroundColor = "#c12c54"));
  btn.addEventListener("mouseout", () => (btn.style.backgroundColor = "#e13b63"));

  
  form.addEventListener("submit", (e) => {
    
    const nombre = document.getElementById("nombre").value.trim();
    const email = document.getElementById("email").value.trim();
    const pass = document.getElementById("password").value;
    const conf = document.getElementById("confirmar").value;

    // VALIDACIÓN CLIENTE: Si algo falla, detenemos el envío
    if (!nombre || !email || !pass || !conf) {
      e.preventDefault();
      alert("Por favor, completa todos los campos.");
      return;
    }

    const correoValido = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
    if (!correoValido) {
      e.preventDefault();
      alert("Por favor, introduce un correo electrónico válido.");
      return;
    }

    if (pass !== conf) {
      e.preventDefault();
      alert("Las contraseñas no coinciden.");
      return;
    }

    console.log("Datos validados en cliente. Enviando al servidor...");
  });
});