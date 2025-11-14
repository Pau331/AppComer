document.addEventListener("DOMContentLoaded", () => {
  const chats = document.querySelectorAll(".chat-card");
  const chatUsuario = document.getElementById("chat-usuario");
  const chatMensajes = document.getElementById("chatMensajes");
  const mensajeInput = document.getElementById("mensajeInput");
  const btnEnviar = document.getElementById("btnEnviar");
  const btnVolver = document.getElementById("btnVolver");
  const chatList = document.querySelector(".chat-list");
  const chatView = document.querySelector("#chatView");
  const chatInput = document.getElementById("chatInput");

  // Secciones
  const seccionSinLeer = document.querySelector(".chat-section.sin-leer");
  const seccionLeidos = document.querySelector(".chat-section.leidos");

  // Conversaciones simuladas
  const conversaciones = {
    "Lucía": [
      { remitente: "Lucía", texto: "¡Tienes que probar mi nueva receta!" },
      { remitente: "Tú", texto: "Claro, mándame los ingredientes" }
    ],
    "Carlos": [
      { remitente: "Carlos", texto: "¿Cómo hiciste el bizcocho?" },
      { remitente: "Tú", texto: "Te paso la receta ahora." }
    ],
    "Ana": [
      { remitente: "Ana", texto: "Te mandé un nuevo postre" },
      { remitente: "Tú", texto: "¡Gracias! Tiene una pinta increíble." }
    ],
    "David": [
      { remitente: "David", texto: "¿Cuándo subes receta nueva?" },
      { remitente: "Tú", texto: "Esta semana" }
    ]
  };

  // Clic en un chat
  chats.forEach(chat => {
    chat.addEventListener("click", () => {
      const usuario = chat.dataset.usuario;
      chatUsuario.textContent = usuario;

      // Mostrar input y habilitar escritura
      chatInput.classList.remove("oculto");
      mensajeInput.disabled = false;
      btnEnviar.disabled = false;
      chatView.dataset.activo = "true";

      // Mostrar conversación
      chatMensajes.innerHTML = "";
      chatMensajes.style.background = "#fafafa";

      if (conversaciones[usuario]) {
        conversaciones[usuario].forEach(msg => {
          const burbuja = document.createElement("div");
          burbuja.classList.add("chat-bubble", msg.remitente === "Tú" ? "user" : "other");
          burbuja.textContent = msg.texto;
          chatMensajes.appendChild(burbuja);
        });
      } else {
        chatMensajes.innerHTML = "<p class='info'>No hay mensajes aún.</p>";
      }

      chatMensajes.scrollTop = chatMensajes.scrollHeight;

      // Mover chat de "sin leer" a "leídos"
      if (chat.classList.contains("unread")) {
        chat.classList.remove("unread");
        if (seccionSinLeer && seccionSinLeer.contains(chat)) seccionSinLeer.removeChild(chat);
        if (seccionLeidos) {
          const primerLeido = seccionLeidos.querySelector(".chat-card");
          primerLeido ? seccionLeidos.insertBefore(chat, primerLeido) : seccionLeidos.appendChild(chat);
        }
      }

      // Marcar activo
      document.querySelectorAll(".chat-card").forEach(c => c.classList.remove("active"));
      chat.classList.add("active");

      // Modo móvil
      if (window.innerWidth <= 800) {
        chatList.style.display = "none";
        chatView.style.display = "flex";
      }
    });
  });

  // Botón volver (móvil)
  btnVolver.addEventListener("click", () => {
    if (window.innerWidth <= 800) {
      chatView.style.display = "none";
      chatList.style.display = "block";
    }
  });

  // Enviar mensaje
  btnEnviar.addEventListener("click", () => {
    const texto = mensajeInput.value.trim();
    if (!texto) return;

    const nuevaBurbuja = document.createElement("div");
    nuevaBurbuja.classList.add("chat-bubble", "user");
    nuevaBurbuja.textContent = texto;
    chatMensajes.appendChild(nuevaBurbuja);

    const usuarioActual = chatUsuario.textContent;
    if (usuarioActual && conversaciones[usuarioActual]) {
      conversaciones[usuarioActual].push({ remitente: "Tú", texto });
    }

    mensajeInput.value = "";
    chatMensajes.scrollTop = chatMensajes.scrollHeight;
  });

  // Enviar con Enter
  mensajeInput.addEventListener("keypress", e => {
    if (e.key === "Enter") {
      e.preventDefault();
      btnEnviar.click();
    }
  });

  // Redirigir al perfil del usuario al hacer clic en su nombre
  chatUsuario.addEventListener("click", () => {
    if (chatView.dataset.activo === "true") {
      window.location.href = "usuario.html";
    }
  });
});
