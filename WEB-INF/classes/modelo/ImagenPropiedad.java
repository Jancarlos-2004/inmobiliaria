package modelo;

public class ImagenPropiedad {
    private int id;
    private int idPropiedad;
    private String urlImagen;

    public ImagenPropiedad() {}

    public ImagenPropiedad(int id, int idPropiedad, String urlImagen) {
        this.id = id;
        this.idPropiedad = idPropiedad;
        this.urlImagen = urlImagen;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getIdPropiedad() { return idPropiedad; }
    public void setIdPropiedad(int idPropiedad) { this.idPropiedad = idPropiedad; }

    public String getUrlImagen() { return urlImagen; }
    public void setUrlImagen(String urlImagen) { this.urlImagen = urlImagen; }
}
