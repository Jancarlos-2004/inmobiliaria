1// scripts.js - Inmobiliaria UTS - Nexus Living Co
// Validaciones de cliente básicas. La validación real de negocio
// SIEMPRE se repite en el servidor (Servlets/DAO), esto es solo UX.

document.addEventListener("DOMContentLoaded", function () {
    var formRegistro = document.querySelector('form[action$="/registro"]');
    if (formRegistro) {
        formRegistro.addEventListener("submit", function (e) {
            var password = formRegistro.querySelector("#password").value;
            var confirmar = formRegistro.querySelector("#confirmarPassword").value;
            if (password !== confirmar) {
                e.preventDefault();
                alert("Las contraseñas no coinciden.");
            }
        });
    }

    inicializarRevelado();
    inicializarCabeceraConScroll();
    inicializarOndaEnBotones();
    inicializarFallbackImagenes();
    inicializarGaleriaPropiedad();
    inicializarMenuMovil();
    inicializarDropdownUsuario();
    inicializarToggleModo();
    inicializarHeroTabs();
    inicializarContadoresKPI();
});

// ---------------------------------------------------------------
// Si una foto de propiedad no carga (URL rota o archivo faltante),
// se reemplaza por el placeholder existente del proyecto en vez de
// mostrar el icono de imagen rota del navegador.
// ---------------------------------------------------------------
function inicializarFallbackImagenes() {
    var galerias = document.querySelectorAll(".galeria img, .tarjeta-propiedad-galeria img, .tarjeta-propiedad > img");
    galerias.forEach(function (img) {
        img.addEventListener("error", function () {
            if (img.dataset.fallbackAplicado) return;
            img.dataset.fallbackAplicado = "1";
            img.src = img.src.replace(/[^\/]+$/, "placeholder.jpg");
            img.alt = "Imagen no disponible";
        });
    });
}

// ---------------------------------------------------------------
// Galeria del detalle de propiedad: foto principal grande,
// miniaturas clicables, contador y lightbox.
// ---------------------------------------------------------------
function inicializarGaleriaPropiedad() {
    var galeria = document.querySelector(".galeria");
    if (!galeria) return;

    var imgPrincipal = galeria.querySelector(".galeria-imagen-principal");
    if (!imgPrincipal) return;

    var miniaturas = Array.prototype.slice.call(galeria.querySelectorAll(".galeria-miniatura"));

    var urls, alts;
    if (miniaturas.length) {
        urls = miniaturas.map(function (mini) { return mini.querySelector("img").getAttribute("src"); });
        alts = miniaturas.map(function (mini) { return mini.querySelector("img").getAttribute("alt"); });
    } else {
        urls = [imgPrincipal.getAttribute("src")];
        alts = [imgPrincipal.getAttribute("alt")];
    }

    var contadorActual = galeria.querySelector(".galeria-contador-actual");
    var contadorTotal  = galeria.querySelector(".galeria-contador-total");
    var btnAmpliar     = galeria.querySelector(".galeria-ampliar");
    var overlay        = null;
    var indiceActual   = 0;

    if (contadorTotal) contadorTotal.textContent = urls.length;

    function mostrar(indice) {
        indiceActual = (indice + urls.length) % urls.length;
        imgPrincipal.src = urls[indiceActual];
        imgPrincipal.alt = alts[indiceActual] || "";
        miniaturas.forEach(function (mini, i) {
            mini.classList.toggle("activa", i === indiceActual);
        });
        if (contadorActual) contadorActual.textContent = indiceActual + 1;
        if (overlay) actualizarLightbox();
    }

    miniaturas.forEach(function (mini, indice) {
        mini.addEventListener("click", function () { mostrar(indice); });
    });

    imgPrincipal.addEventListener("click", function () { abrirLightbox(indiceActual); });
    if (btnAmpliar) btnAmpliar.addEventListener("click", function () { abrirLightbox(indiceActual); });

    function abrirLightbox(indice) {
        indiceActual = indice;
        overlay = document.createElement("div");
        overlay.className = "lightbox-overlay";
        overlay.innerHTML =
            '<div class="lightbox-figura">' +
                '<img src="" alt="">' +
                (urls.length > 1 ?
                    '<button type="button" class="lightbox-prev" aria-label="Anterior"><svg viewBox="0 0 24 24"><path d="M15 6l-6 6 6 6"/></svg></button>' +
                    '<button type="button" class="lightbox-next" aria-label="Siguiente"><svg viewBox="0 0 24 24"><path d="M9 6l6 6-6 6"/></svg></button>'
                    : '') +
                '<button type="button" class="lightbox-cerrar" aria-label="Cerrar"><svg viewBox="0 0 24 24"><path d="M6 6l12 12M18 6L6 18"/></svg></button>' +
                (urls.length > 1 ? '<div class="lightbox-contador"></div>' : '') +
            '</div>';
        document.body.appendChild(overlay);
        document.body.style.overflow = "hidden";
        actualizarLightbox();

        overlay.addEventListener("click", function (e) {
            if (e.target === overlay) cerrarLightbox();
        });
        var btnCerrar = overlay.querySelector(".lightbox-cerrar");
        if (btnCerrar) btnCerrar.addEventListener("click", cerrarLightbox);
        var btnPrev = overlay.querySelector(".lightbox-prev");
        if (btnPrev) btnPrev.addEventListener("click", function () { mostrar(indiceActual - 1); });
        var btnNext = overlay.querySelector(".lightbox-next");
        if (btnNext) btnNext.addEventListener("click", function () { mostrar(indiceActual + 1); });

        document.addEventListener("keydown", alPresionarTecla);
    }

    function actualizarLightbox() {
        if (!overlay) return;
        var imgDestino = overlay.querySelector("img");
        imgDestino.src = urls[indiceActual];
        imgDestino.alt = alts[indiceActual] || "";
        var contador = overlay.querySelector(".lightbox-contador");
        if (contador) contador.textContent = (indiceActual + 1) + " / " + urls.length;
    }

    function alPresionarTecla(e) {
        if (!overlay) return;
        if (e.key === "Escape") cerrarLightbox();
        if (e.key === "ArrowLeft") mostrar(indiceActual - 1);
        if (e.key === "ArrowRight") mostrar(indiceActual + 1);
    }

    function cerrarLightbox() {
        if (!overlay) return;
        document.removeEventListener("keydown", alPresionarTecla);
        document.body.style.overflow = "";
        overlay.remove();
        overlay = null;
    }
}

// ---------------------------------------------------------------
// Revelado progresivo: las tarjetas, tablas y formularios aparecen
// suavemente a medida que entran en el viewport.
// ---------------------------------------------------------------
function inicializarRevelado() {
    var selector = [
        ".tarjeta-formulario",
        ".tarjeta-propiedad",
        ".detalle-propiedad",
        ".sin-resultados",
        ".cabecera-seccion",
        "table.tabla-simple",
        ".seccion-tipos-inmueble",
        ".seccion-zonas",
        ".seccion-beneficios",
        ".seccion-cta-final",
        ".seccion-destacadas"
    ].join(", ");

    var elementos = document.querySelectorAll(selector);
    if (!elementos.length) return;

    elementos.forEach(function (el, indice) {
        el.classList.add("al-vista");
        el.style.transitionDelay = Math.min(indice * 55, 330) + "ms";
    });

    if (!("IntersectionObserver" in window)) {
        elementos.forEach(function (el) { el.classList.add("visible"); });
        return;
    }

    var observador = new IntersectionObserver(function (entradas) {
        entradas.forEach(function (entrada) {
            if (entrada.isIntersecting) {
                entrada.target.classList.add("visible");
                observador.unobserve(entrada.target);
            }
        });
    }, { threshold: 0.08 });

    elementos.forEach(function (el) { observador.observe(el); });
}

// ---------------------------------------------------------------
// La cabecera gana una sombra sutil al hacer scroll hacia abajo.
// ---------------------------------------------------------------
function inicializarCabeceraConScroll() {
    var cabecera = document.querySelector(".cabecera");
    if (!cabecera) return;

    var alActualizar = function () {
        cabecera.classList.toggle("cabecera--con-scroll", window.scrollY > 8);
    };
    alActualizar();
    window.addEventListener("scroll", alActualizar, { passive: true });
}

// ---------------------------------------------------------------
// Pequeño efecto de onda al pulsar los botones principales.
// ---------------------------------------------------------------
function inicializarOndaEnBotones() {
    document.querySelectorAll(".boton-primario, .boton-cta-final").forEach(function (boton) {
        boton.addEventListener("click", function (e) {
            var rect = boton.getBoundingClientRect();
            var tam  = Math.max(rect.width, rect.height);
            var onda = document.createElement("span");
            onda.className = "onda-clic";
            onda.style.width  = onda.style.height = tam + "px";
            onda.style.left   = (e.clientX - rect.left - tam / 2) + "px";
            onda.style.top    = (e.clientY - rect.top  - tam / 2) + "px";
            boton.appendChild(onda);
            window.setTimeout(function () { onda.remove(); }, 650);
        });
    });
}

// ---------------------------------------------------------------
// Menú hamburguesa para móvil.
// ---------------------------------------------------------------
function inicializarMenuMovil() {
    var btnHamburguesa = document.querySelector(".menu-hamburguesa");
    var menuMovil      = document.querySelector(".menu-movil");
    var overlay        = document.querySelector(".menu-movil-overlay");
    var btnCerrar      = document.querySelector(".menu-movil-cerrar");

    if (!btnHamburguesa || !menuMovil) return;

    function abrirMenu() {
        menuMovil.classList.add("activo");
        if (overlay) overlay.classList.add("activo");
        document.body.style.overflow = "hidden";
        btnHamburguesa.setAttribute("aria-expanded", "true");
    }

    function cerrarMenu() {
        menuMovil.classList.remove("activo");
        if (overlay) overlay.classList.remove("activo");
        document.body.style.overflow = "";
        btnHamburguesa.setAttribute("aria-expanded", "false");
    }

    btnHamburguesa.addEventListener("click", abrirMenu);
    if (btnCerrar)  btnCerrar.addEventListener("click", cerrarMenu);
    if (overlay)    overlay.addEventListener("click", cerrarMenu);

    document.addEventListener("keydown", function (e) {
        if (e.key === "Escape") cerrarMenu();
    });
}

// ---------------------------------------------------------------
// Dropdown de usuario en el navbar.
// ---------------------------------------------------------------
function inicializarDropdownUsuario() {
    var dropdown = document.querySelector(".usuario-dropdown");
    if (!dropdown) return;

    var btn  = dropdown.querySelector(".usuario-dropdown-btn");
    var menu = dropdown.querySelector(".usuario-dropdown-menu");

    if (!btn || !menu) return;

    function toggleDropdown(e) {
        e.stopPropagation();
        dropdown.classList.toggle("activo");
    }

    function cerrarDropdown() {
        dropdown.classList.remove("activo");
    }

    btn.addEventListener("click", toggleDropdown);

    document.addEventListener("click", function (e) {
        if (!dropdown.contains(e.target)) {
            cerrarDropdown();
        }
    });

    document.addEventListener("keydown", function (e) {
        if (e.key === "Escape") cerrarDropdown();
    });
}

// ---------------------------------------------------------------
// Toggle de modo oscuro con persistencia en localStorage.
// Aplica el atributo data-tema al elemento <html>.
// ---------------------------------------------------------------
function inicializarToggleModo() {
    var btnModo = document.querySelector(".boton-modo");
    var html    = document.documentElement;

    // Aplicar tema guardado inmediatamente al cargar
    var temaGuardado = localStorage.getItem("nexus-tema");
    if (temaGuardado === "oscuro") {
        html.setAttribute("data-tema", "oscuro");
    }

    if (!btnModo) return;

    btnModo.addEventListener("click", function () {
        var temaActual = html.getAttribute("data-tema");
        if (temaActual === "oscuro") {
            html.removeAttribute("data-tema");
            localStorage.setItem("nexus-tema", "claro");
            btnModo.setAttribute("aria-label", "Activar modo oscuro");
        } else {
            html.setAttribute("data-tema", "oscuro");
            localStorage.setItem("nexus-tema", "oscuro");
            btnModo.setAttribute("aria-label", "Activar modo claro");
        }
    });

    // Actualizar aria-label inicial
    if (temaGuardado === "oscuro") {
        btnModo.setAttribute("aria-label", "Activar modo claro");
    } else {
        btnModo.setAttribute("aria-label", "Activar modo oscuro");
    }
}

// ---------------------------------------------------------------
// Tabs del hero (Comprar / Arrendar).
// Solo cambia la clase activo para estilo visual.
// No modifica parámetros de búsqueda backend.
// ---------------------------------------------------------------
function inicializarHeroTabs() {
    var tabs = document.querySelectorAll(".hero-tab");
    if (!tabs.length) return;

    tabs.forEach(function (tab) {
        tab.addEventListener("click", function () {
            tabs.forEach(function (t) { t.classList.remove("activo"); });
            tab.classList.add("activo");

            // Si hay un input de búsqueda en el hero, añadir hint visual
            var inputBusqueda = document.querySelector(".formulario-busqueda input[name='q']");
            if (inputBusqueda) {
                var tipo = tab.dataset.tipo || "";
                inputBusqueda.placeholder = tipo
                    ? "Buscar inmueble en " + tipo.toLowerCase() + "..."
                    : "Ciudad, barrio o palabra clave...";
            }
        });
    });
}

// ---------------------------------------------------------------
// Contadores animados en tarjetas KPI.
// Anima el número desde 0 hasta el valor final cuando el elemento
// entra en el viewport. No modifica datos del servidor.
// ---------------------------------------------------------------
function inicializarContadoresKPI() {
    var contadores = document.querySelectorAll(".kpi-valor[data-valor]");
    if (!contadores.length) return;

    if (!("IntersectionObserver" in window)) {
        contadores.forEach(function (el) {
            el.textContent = el.dataset.valor;
        });
        return;
    }

    var obs = new IntersectionObserver(function (entradas) {
        entradas.forEach(function (entrada) {
            if (!entrada.isIntersecting) return;
            var el     = entrada.target;
            var final  = parseInt(el.dataset.valor, 10);
            if (isNaN(final)) { el.textContent = el.dataset.valor; return; }
            var duracion = 1200;
            var inicio   = performance.now();
            obs.unobserve(el);

            function paso(ahora) {
                var progreso  = Math.min((ahora - inicio) / duracion, 1);
                // Ease-out cuadrático
                var easedProg = 1 - Math.pow(1 - progreso, 2);
                el.textContent = Math.round(easedProg * final);
                if (progreso < 1) requestAnimationFrame(paso);
            }
            requestAnimationFrame(paso);
        });
    }, { threshold: 0.3 });

    contadores.forEach(function (el) { obs.observe(el); });
}

// ---------------------------------------------------------------
// Aplica tema guardado ANTES de que el DOM esté listo para
// evitar flash de contenido sin tema.
// ---------------------------------------------------------------
(function () {
    try {
        var t = localStorage.getItem("nexus-tema");
        if (t === "oscuro") {
            document.documentElement.setAttribute("data-tema", "oscuro");
        }
    } catch (e) { /* localStorage no disponible */ }
}());
