function H = CameraRotationHomography(Rsrc,Rdst,K)
H = K * Rdst * Rsrc' * inv(K);