document.addEventListener("DOMContentLoaded", () => {
  const formLogin = document.getElementById("formLogin");
  const formRecuperar = document.getElementById("formRecuperar");
  const btnLogin = document.getElementById("btnLogin");
  const btnRecuperar = document.getElementById("btnRecuperar");
  const linkOlvide = document.getElementById("linkOlvide");
  const linkVolver = document.getElementById("linkVolver");

  // Efecto hover coherente con el color principal
  const hoverIn = (btn) => (btn.style.backgroundColor = "#c12c54");
  const hoverOut = (btn) => (btn.style.backgroundColor = "#e13b63");
  [btnLogin, btnRecuperar].forEach((btn) => {
    btn.addEventListener("mouseover", () => hoverIn(btn));
    btn.addEventListener("mouseout", () => hoverOut(btn));
  });

  // Envío de formulario de inicio de sesión
  formLogin.addEventListener("submit", (e) => {
    e.preventDefault();

    const usuario = document.getElementById("usuario").value.trim();
    const password = document.getElementById("password").value.trim();

    if (!usuario || !password) {
      alert("Por favor, completa todos los campos.");
      return;
    }

    const esCorreo = usuario.includes("@");
    if (esCorreo) {
      const correoValido = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(usuario);
      if (!correoValido) {
        alert("Por favor, introduce un correo electrónico válido.");
        return;
      }
    } else if (usuario.length < 3) {
      alert("El nombre de usuario debe tener al menos 3 caracteres.");
      return;
    }

    //alert(`Inicio de sesión exitoso. ¡Bienvenido/a, ${usuario}!`);
    //formLogin.reset();
    window.location.href = "menu.html";
  });

  // Mostrar formulario de recuperación
  linkOlvide.addEventListener("click", (e) => {
    e.preventDefault();
    formLogin.classList.add("oculto");
    formRecuperar.classList.remove("oculto");
  });

  // Volver al formulario de inicio
  linkVolver.addEventListener("click", (e) => {
    e.preventDefault();
    formRecuperar.classList.add("oculto");
    formLogin.classList.remove("oculto");
  });

  //Envío del formulario de recuperación
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
