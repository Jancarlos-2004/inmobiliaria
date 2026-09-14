package modelo;

public class Caracteristica {
    private int id;
    private String nombre;

    public Caracteristica() {}

    public Caracteristica(int id, String nombre) {
        this.id = id;
        this.nombre = nombre;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
}
