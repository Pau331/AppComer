const $ = s => document.querySelector(s);
const $$ = s => document.querySelectorAll(s);

// --- Pasos dinámicos ---
const lista = $("#listaPasosEdit");
const btnAddPaso = $("#btnAddPaso");

function addPaso(texto = "") {
  const li = document.createElement("li");
  li.className = "step-row";
  li.innerHTML = `
    <input type="text" placeholder="Escribe el paso..." value="${texto.replace(/"/g, '&quot;')}" />
    <button class="del" title="Eliminar"><i class="fa-solid fa-trash"></i></button>
  `;
  li.querySelector(".del").addEventListener("click", () => li.remove());
  lista.appendChild(li);
}

btnAddPaso.addEventListener("click", () => addPaso(""));

// Añadimos un par por defecto
addPaso("Precalienta el horno a 180ºC y engrasa un molde.");
addPaso("Mezcla los ingredientes y hornea.");

// --- Upload/preview imagen ---
const drop = $("#dropFoto");
const inputFile = $("#fotoInput");
const prev = $("#prevFoto");
const ph = $("#placeholderFoto");

function showPreview(file) {
  const url = URL.createObjectURL(file);
  prev.src = url;
  prev.style.display = "block";
  ph.style.display = "none";
}

drop.addEventListener("click", () => inputFile.click());
inputFile.addEventListener("change", (e) => {
  const f = e.target.files?.[0];
  if (f) showPreview(f);
});
drop.addEventListener("dragover", e => { e.preventDefault(); drop.classList.add("drag"); });
drop.addEventListener("dragleave", () => drop.classList.remove("drag"));
drop.addEventListener("drop", e => {
  e.preventDefault();
  drop.classList.remove("drag");
  const f = e.dataTransfer.files?.[0];
  if (f) { inputFile.files = e.dataTransfer.files; showPreview(f); }
});

// --- Guardar receta vía Servlet ---
$("#btnGuardar").addEventListener("click", async () => {
  const titulo = $("#tituloInput").value.trim();
  const dificultad = $("#dificultad").value;
  const tiempo = $("#tiempo").value.trim();
  const dietas = [...$$(".dietas-select input:checked")].map(i => i.value);
  const pasos = [...$$(".step-row input")].map(i => i.value.trim()).filter(Boolean);
  const fotoFile = inputFile.files?.[0];

  if (!titulo) { alert("Pon un título a la receta."); return; }
  if (pasos.length === 0) { alert("Añade al menos un paso."); return; }

  const formData = new FormData();
  formData.append("titulo", titulo);
  formData.append("dificultad", dificultad);
  formData.append("tiempo", tiempo);
  formData.append("pasos", JSON.stringify(pasos)); // enviamos array como JSON
  dietas.forEach(d => formData.append("dietas", d)); // múltiples valores
  if (fotoFile) formData.append("foto", fotoFile);

  try {
    const resp = await fetch("receta", { // URL de tu RecetaServlet
      method: "POST",
      body: formData
    });

    if (resp.ok) {
      alert("Receta guardada correctamente.");
      window.location.href = "menu.jsp"; // redirige al feed
    } else {
      const text = await resp.text();
      alert("Error al guardar la receta:\n" + text);
    }
  } catch (err) {
    console.error(err);
    alert("Error en la conexión con el servidor.");
  }
});
