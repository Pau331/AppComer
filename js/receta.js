const $ = s => document.querySelector(s);

const receta = {
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
