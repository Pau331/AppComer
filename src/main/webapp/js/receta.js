const $ = s => document.querySelector(s);

const receta = {
  usuario: "ChefAna",
  foto_perfil: "https://i.pravatar.cc/60?img=5",
  titulo: "Brownies de Chocolate",
  tiempo: "20 min",
  dificultad: "Baja",
  dietas: ["Sin gluten"],   // puedes añadir "Healthy" o "Vegetariano"
  pasos: [
    "Precalienta el horno a 180ºC y engrasa un molde.",
    "Derrite chocolate y mantequilla; mezcla con azúcar.",
    "Añade huevos; integra harina y una pizca de sal.",
    "Hornea 20–25 minutos; deja templar.",
    "Corta en cuadrados y sirve."
  ],
  likes: 128
};

// Pintar datos
$("#fotoUsuario").src = receta.foto_perfil;
$("#nombreUsuario").textContent = "@" + receta.usuario;
$("#tituloReceta").textContent = receta.titulo;
$("#difText").textContent = receta.dificultad;
$("#tiempoText").textContent = receta.tiempo;

// Dietas con iconos como en inicio
$("#dietasLista").innerHTML = receta.dietas.map(d => {
  const t = d.toLowerCase();
  if (t.includes("gluten"))
    return `<img src="../img/sin-gluten.png" class="diet-icon" alt="Sin gluten"><span>Sin gluten</span>`;
  if (t === "healthy")
    return `<i class="fa-solid fa-heart-pulse"></i><span>Healthy</span>`;
  if (t === "vegetariano")
    return `<i class="fa-solid fa-carrot"></i><span>Vegetariano</span>`;
  return "";
}).join("");

// Pasos
$("#listaPasos").innerHTML = receta.pasos.map(p=>`<li>${p}</li>`).join("");

// Like(demo)
let liked = false;

const btnLike = $("#btnLike");
const likeNum = $("#likeNum");
const heartIcon = btnLike.querySelector("i");

btnLike.addEventListener("click", () => {
  liked = !liked;
  receta.likes += liked ? 1 : -1;
  likeNum.textContent = receta.likes;

  // Cambiar la clase del corazón según like
  if (liked) {
    heartIcon.classList.remove("fa-regular");
    heartIcon.classList.add("fa-solid");
  } else {
    heartIcon.classList.remove("fa-solid");
    heartIcon.classList.add("fa-regular");
  }
});
// Array de comentarios demo con fecha
const comentarios = [
  { usuario: "chefCarlos", avatar: "https://i.pravatar.cc/40?img=12", texto: "¡Se ve delicioso!", fecha: new Date(Date.now() - 2 * 60 * 60 * 1000) }, // hace 2h
  { usuario: "laura_tartas", avatar: "https://i.pravatar.cc/40?img=27", texto: "Tengo que probar esta receta.", fecha: new Date(Date.now() - 3 * 24 * 60 * 60 * 1000) } // hace 3d
];

// Función para obtener fecha relativa
function fechaRelativa(fecha) {
  const ahora = new Date();
  const diff = ahora - fecha; // diferencia en ms
  const segundos = Math.floor(diff / 1000);
  const minutos = Math.floor(segundos / 60);
  const horas = Math.floor(minutos / 60);
  const dias = Math.floor(horas / 24);
  const meses = Math.floor(dias / 30);
  const años = Math.floor(dias / 365);

  if (dias === 0) return "hoy";
  if (dias < 30) return `${dias}d`;
  if (meses < 12) return `${meses}m`;
  return `${años}y`;
}

// Función para renderizar los comentarios
function mostrarComentarios() {
  const lista = document.getElementById("listaComentarios");
  lista.innerHTML = "";
  comentarios.forEach(c => {
    const div = document.createElement("div");
    div.classList.add("comment");
    div.innerHTML = `
      <img src="${c.avatar}" alt="${c.usuario}" class="avatar">
      <div class="content">
        <div class="username">@${c.usuario} <span class="fecha">${fechaRelativa(new Date(c.fecha))}</span></div>
        <div class="texto">${c.texto}</div>
      </div>
    `;
    lista.appendChild(div);
  });
}

// Inicializar comentarios al cargar
mostrarComentarios();

// Agregar nuevo comentario con fecha actual
const btnAgregar = document.getElementById("btnAgregarComentario");
btnAgregar.addEventListener("click", () => {
  const textarea = document.getElementById("nuevoComentario");
  const texto = textarea.value.trim();
  if (texto) {
    comentarios.push({
      usuario: "Yo",
      avatar: "https://i.pravatar.cc/40?img=5",
      texto,
      fecha: new Date()
    });
    textarea.value = "";
    mostrarComentarios();
  }
});
