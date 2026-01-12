const $ = s => document.querySelector(s);
const $$ = s => document.querySelectorAll(s);

// --- Función para mostrar notificaciones ---
function mostrarNotificacion(mensaje, tipo = 'info') {
  const notif = document.createElement('div');
  notif.className = `notificacion notif-${tipo}`;
  notif.textContent = mensaje;
  notif.style.cssText = `
    position: fixed;
    top: 90px;
    right: 20px;
    background: ${tipo === 'error' ? '#e13b63' : tipo === 'success' ? '#1f8b4c' : '#333'};
    color: white;
    padding: 16px 24px;
    border-radius: 8px;
    box-shadow: 0 4px 12px rgba(0,0,0,0.15);
    z-index: 10000;
    font-weight: 600;
    animation: slideIn 0.3s ease;
  `;
  document.body.appendChild(notif);
  
  setTimeout(() => {
    notif.style.animation = 'slideOut 0.3s ease';
    setTimeout(() => notif.remove(), 300);
  }, 3000);
}

// Agregar animaciones CSS si no existen
if (!document.getElementById('notif-animations')) {
  const style = document.createElement('style');
  style.id = 'notif-animations';
  style.textContent = `
    @keyframes slideIn {
      from { transform: translateX(400px); opacity: 0; }
      to { transform: translateX(0); opacity: 1; }
    }
    @keyframes slideOut {
      from { transform: translateX(0); opacity: 1; }
      to { transform: translateX(400px); opacity: 0; }
    }
  `;
  document.head.appendChild(style);
}

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
$("#btnGuardar").addEventListener("click", async (e) => {
  e.preventDefault(); // Prevenir envío del formulario
  const titulo = $("#tituloInput").value.trim();
  const dificultad = $("#dificultad").value;
  const tiempo = $("#tiempo").value.trim();
  const dietas = [...$$(".dietas-select input:checked")].map(i => i.value);
  const pasos = [...$$(".step-row input")].map(i => i.value.trim()).filter(Boolean);
  const fotoFile = inputFile.files?.[0];

  if (!titulo) { mostrarNotificacion("Pon un título a la receta.", "error"); return; }
  if (pasos.length === 0) { mostrarNotificacion("Añade al menos un paso.", "error"); return; }

  const formData = new FormData();
  formData.append("titulo", titulo);
  formData.append("dificultad", dificultad);
  formData.append("tiempo", tiempo);
  // Enviar pasos separados por |
  formData.append("pasos", pasos.join("|"));
  dietas.forEach(d => formData.append("dietas", d)); // múltiples valores
  if (fotoFile) formData.append("foto", fotoFile);

  try {
    const resp = await fetch(CONTEXT_PATH + "/receta/crear", { // URL de tu RecetaServlet
      method: "POST",
      body: formData
    });

    const result = await resp.json();
    if (result.success) {
      mostrarNotificacion("Receta guardada correctamente.", "success");
      setTimeout(() => {
        window.location.href = CONTEXT_PATH + "/receta/feed"; // redirige al feed
      }, 1500);
    } else {
      mostrarNotificacion("Error al guardar: " + (result.message || "Error desconocido"), "error");
    }
  } catch (err) {
    console.error(err);
    mostrarNotificacion("Error en la conexión con el servidor.", "error");
  }
});
