document.addEventListener("DOMContentLoaded", () => {
  const formLogin = document.getElementById("formLogin");
  const formRecuperar = document.getElementById("formRecuperar");
  const btnLogin = document.getElementById("btnLogin");
  const btnRecuperar = document.getElementById("btnRecuperar");
  const linkOlvide = document.getElementById("linkOlvide");
  const linkVolver = document.getElementById("linkVolver");

  const hoverIn = (btn) => (btn.style.backgroundColor = "#c12c54");
  const hoverOut = (btn) => (btn.style.backgroundColor = "#e13b63");
  [btnLogin, btnRecuperar].forEach((btn) => {
    btn.addEventListener("mouseover", () => hoverIn(btn));
    btn.addEventListener("mouseout", () => hoverOut(btn));
  });

  // Envío de formulario de inicio de sesión modificado para Backend
  formLogin.addEventListener("submit", (e) => {
    const usuario = document.getElementById("usuario").value.trim();
    const password = document.getElementById("password").value.trim();

    // 1. Validaciones previas en el cliente
    if (!usuario || !password) {
      e.preventDefault(); // Detener solo si hay error
      alert("Por favor, completa todos los campos.");
      return;
    }

    const esCorreo = usuario.includes("@");
    if (esCorreo) {
      const correoValido = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(usuario);
      if (!correoValido) {
        e.preventDefault();
        alert("Por favor, introduce un correo electrónico válido.");
        return;
      }
    } else if (usuario.length < 3) {
      e.preventDefault();
      alert("El nombre de usuario debe tener al menos 3 caracteres.");
      return;
    }

  });

  linkOlvide.addEventListener("click", (e) => {
    e.preventDefault();
    formLogin.classList.add("oculto");
    formRecuperar.classList.remove("oculto");
  });

  linkVolver.addEventListener("click", (e) => {
    e.preventDefault();
    formRecuperar.classList.add("oculto");
    formLogin.classList.remove("oculto");
  });

  // El formulario de recuperación sigue siendo simulado por ahora
  formRecuperar.addEventListener("submit", (e) => {
    e.preventDefault();
    const correo = document.getElementById("correoRecuperar").value.trim();
    const correoValido = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(correo);

    if (!correoValido) {
      alert("Por favor, introduce un correo electrónico válido.");
      return;
    }

    alert(`Hemos enviado un enlace de recuperación a ${correo}`);
    formRecuperar.reset();
    formRecuperar.classList.add("oculto");
    formLogin.classList.remove("oculto");
  });
});