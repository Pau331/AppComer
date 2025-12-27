document.addEventListener("DOMContentLoaded", () => {
  const form = document.getElementById("formRegistro");
  const btn = document.getElementById("btnRegistrar");

  // Efecto hover del botón (rosa)
  btn.addEventListener("mouseover", () => (btn.style.backgroundColor = "#c12c54"));
  btn.addEventListener("mouseout", () => (btn.style.backgroundColor = "#e13b63"));

  // Validación y envío del formulario
  form.addEventListener("submit", (e) => {
    e.preventDefault();

    const nombre = document.getElementById("nombre").value.trim();
    const email = document.getElementById("email").value.trim();
    const pass = document.getElementById("password").value;
    const conf = document.getElementById("confirmar").value;

    if (!nombre || !email || !pass || !conf) {
      alert("Por favor, completa todos los campos.");
      return;
    }

    const correoValido = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
    if (!correoValido) {
      alert("Por favor, introduce un correo electrónico válido.");
      return;
    }

    if (pass !== conf) {
      alert("Las contraseñas no coinciden.");
      return;
    }

    alert(`¡Registro exitoso! Bienvenido/a, ${nombre}.`);
    form.reset();
  });
});
