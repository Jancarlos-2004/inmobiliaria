package modelo;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class Propiedad {
    private int id;
    private String titulo;
    private String descripcion;
    private String direccion;
    private double precio;
    private String matriculaInmobiliaria;
    private int idCiudad;
    private String ciudadNombre;
    private int idTipo;
    private String tipoNombre;
    private int idAgente;
    private String agenteNombre;
    private String estado; // disponible, arrendado, vendido, inactivo (baja logica)
    private Date fechaCreacion;
    
    private List<String> imagenes = new ArrayList<>();
    private List<String> caracteristicas = new ArrayList<>();

    public Propiedad() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitulo() { return titulo; }
    public void setTitulo(String titulo) { this.titulo = titulo; }

    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }

    public String getDireccion() { return direccion; }
    public void setDireccion(String direccion) { this.direccion = direccion; }

    public double getPrecio() { return precio; }
    public void setPrecio(double precio) { this.precio = precio; }

    public String getMatriculaInmobiliaria() { return matriculaInmobiliaria; }
    public void setMatriculaInmobiliaria(String matriculaInmobiliaria) { this.matriculaInmobiliaria = matriculaInmobiliaria; }

    public int getIdCiudad() { return idCiudad; }
    public void setIdCiudad(int idCiudad) { this.idCiudad = idCiudad; }

    public String getCiudadNombre() { return ciudadNombre; }
    public void setCiudadNombre(String ciudadNombre) { this.ciudadNombre = ciudadNombre; }

    public int getIdTipo() { return idTipo; }
    public void setIdTipo(int idTipo) { this.idTipo = idTipo; }

    public String getTipoNombre() { return tipoNombre; }
    public void setTipoNombre(String tipoNombre) { this.tipoNombre = tipoNombre; }

    public int getIdAgente() { return idAgente; }
    public void setIdAgente(int idAgente) { this.idAgente = idAgente; }

    public String getAgenteNombre() { return agenteNombre; }
    public void setAgenteNombre(String agenteNombre) { this.agenteNombre = agenteNombre; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }

    public Date getFechaCreacion() { return fechaCreacion; }
    public void setFechaCreacion(Date fechaCreacion) { this.fechaCreacion = fechaCreacion; }

    public List<String> getImagenes() { return imagenes; }
    public void setImagenes(List<String> imagenes) { this.imagenes = imagenes; }
    
    public void addImagen(String url) {
        this.imagenes.add(url);
    }
    
    public String getPrimeraImagen() {
        if (imagenes != null && !imagenes.isEmpty()) {
            return imagenes.get(0);
        }
        return "assets/img/propiedades/placeholder.jpg";
    }

    public List<String> getCaracteristicas() { return caracteristicas; }
    public void setCaracteristicas(List<String> caracteristicas) { this.caracteristicas = caracteristicas; }
    
    public void addCaracteristica(String c) {
        this.caracteristicas.add(c);
    }
}
