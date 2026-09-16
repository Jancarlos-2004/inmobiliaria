package modelo;

import java.util.ArrayList;
import java.util.List;

public class Usuario {
    private int id;
    private String correo;
    private String passwordHash;
    private String passwordSalt;
    private String estado; // activo, inactivo
    private Perfil perfil;
    private List<String> roles = new ArrayList<>();

    public Usuario() {}

    public Usuario(int id, String correo, String passwordHash, String passwordSalt, String estado) {
        this.id = id;
        this.correo = correo;
        this.passwordHash = passwordHash;
        this.passwordSalt = passwordSalt;
        this.estado = estado;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getCorreo() { return correo; }
    public void setCorreo(String correo) { this.correo = correo; }

    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }

    public String getPasswordSalt() { return passwordSalt; }
    public void setPasswordSalt(String passwordSalt) { this.passwordSalt = passwordSalt; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }

    public Perfil getPerfil() { return perfil; }
    public void setPerfil(Perfil perfil) { this.perfil = perfil; }

    public List<String> getRoles() { return roles; }
    public void setRoles(List<String> roles) { this.roles = roles; }
    
    public void addRol(String rol) {
        if (!this.roles.contains(rol)) {
            this.roles.add(rol);
        }
    }

    public boolean tieneRol(String rol) {
        return this.roles.contains(rol);
    }
}
