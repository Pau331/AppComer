const $ = s => document.querySelector(s);

// Valores demo precargados
const data = {
  nombre: "Luisa Fernández",
  usuario: "chef_luisa",
  bio: "Amante de la pasta, el pan casero y el café ☕",
  avatarUrl: "https://i.pravatar.cc/72?img=10"
};

// Pintar valores
$("#nombre").value = data.nombre;
$("#usuario").value = data.usuario;
$("#bio").value = data.bio;

// Avatar preview
const drop = $("#dropAvatar");
const input = $("#avatarInput");
const prev = $("#prevAvatar");
const ph = $("#placeholderAvatar");

function showAvatar(fileOrUrl){
  if(typeof fileOrUrl === "string"){
    prev.src = fileOrUrl;
  }else{
    const url = URL.createObjectURL(fileOrUrl);
    prev.src = url;
  }
  prev.style.display = "block";
  ph.style.display = "none";
}
// pinta el actual
showAvatar(data.avatarUrl);

drop.addEventListener("click", ()=> input.click());
input.addEventListener("change", e=>{
  const f = e.target.files?.[0];
  if(f) showAvatar(f);
});

drop.addEventListener("dragover", e=>{ e.preventDefault(); drop.classList.add("drag"); });
drop.addEventListener("dragleave", ()=> drop.classList.remove("drag"));
drop.addEventListener("drop", e=>{
  e.preventDefault(); drop.classList.remove("drag");
  const f = e.dataTransfer.files?.[0];
  if(f){ input.files = e.dataTransfer.files; showAvatar(f); }
});

// Guardar (demo)
$("#btnGuardarPerfil").addEventListener("click", ()=>{
  const nombre = $("#nombre").value.trim();
  const usuario = $("#usuario").value.trim().replace(/^@/,'');
  const bio = $("#bio").value.trim();

  if(!nombre || !usuario){ alert("Rellena nombre y usuario."); return; }

  console.log({ nombre, usuario, bio, avatar: input.files?.[0]?.name || "(sin cambio)" });
  alert("✅ Perfil guardado (demo). En la Parte 2 se persistirá en servidor/BD.");
});
