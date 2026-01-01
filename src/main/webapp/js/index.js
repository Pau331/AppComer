document.addEventListener("DOMContentLoaded", () => {
  const btnLogin = document.getElementById("btnLogin");
  const btnRegistro = document.getElementById("btnRegistro");

  // Animación hover suave
  [btnLogin, btnRegistro].forEach((btn) => {
    btn.addEventListener("mouseover", () => {
      btn.style.transform = "scale(1.04)";
    });
    btn.addEventListener("mouseout", () => {
      btn.style.transform = "scale(1)";
    });
  });

  // Redirecciones
  btnLogin.addEventListener("click", () => {
    window.location.href = "jsp/logIn.jsp";
  });

  btnRegistro.addEventListener("click", () => {
    window.location.href = "jsp/registro.jsp";
  });
});
