package modelo;

public class DocumentoSolicitud {
    private int id;
    private int idSolicitud;
    private String nombreArchivo;
    private String rutaArchivo;
    private String tipoDocumento; // identificacion, ingresos, contrato, otro

    public DocumentoSolicitud() {}

    public DocumentoSolicitud(int id, int idSolicitud, String nombreArchivo, String rutaArchivo, String tipoDocumento) {
        this.id = id;
        this.idSolicitud = idSolicitud;
        this.nombreArchivo = nombreArchivo;
        this.rutaArchivo = rutaArchivo;
        this.tipoDocumento = tipoDocumento;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getIdSolicitud() { return idSolicitud; }
    public void setIdSolicitud(int idSolicitud) { this.idSolicitud = idSolicitud; }

    public String getNombreArchivo() { return nombreArchivo; }
    public void setNombreArchivo(String nombreArchivo) { this.nombreArchivo = nombreArchivo; }

    public String getRutaArchivo() { return rutaArchivo; }
    public void setRutaArchivo(String rutaArchivo) { this.rutaArchivo = rutaArchivo; }

    public String getTipoDocumento() { return tipoDocumento; }
    public void setTipoDocumento(String tipoDocumento) { this.tipoDocumento = tipoDocumento; }
}
