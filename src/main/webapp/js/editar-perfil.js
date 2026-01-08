const $ = s => document.querySelector(s);

// Avatar preview (Lógica para ver la foto antes de subirla)
const drop = $("#dropAvatar");
const input = $("#avatarInput");
const prev = $("#prevAvatar");
const ph = $("#placeholderAvatar");

function showAvatar(fileOrUrl){
  if(typeof fileOrUrl === "string"){
    prev.src = fileOrUrl;
  } else {
    const url = URL.createObjectURL(fileOrUrl);
    prev.src = url;
  }
  prev.style.display = "block";
  ph.style.display = "none";
}

// Eventos para el cambio de foto
drop.addEventListener("click", ()=> input.click());
input.addEventListener("change", e => {
  const f = e.target.files?.[0];
  if(f) showAvatar(f);
});

// Lógica de Drag & Drop (mantener igual)
drop.addEventListener("dragover", e => { e.preventDefault(); drop.classList.add("drag"); });
drop.addEventListener("dragleave", () => drop.classList.remove("drag"));
drop.addEventListener("drop", e => {
  e.preventDefault(); 
  drop.classList.remove("drag");
  const f = e.dataTransfer.files?.[0];
  if(f){ 
      input.files = e.dataTransfer.files; 
      showAvatar(f); 
  }
});