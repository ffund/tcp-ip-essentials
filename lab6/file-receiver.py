import socket

sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM) 
sock.bind(('10.10.2.100', 4000))
sock.listen()

conn_sock, conn_addr = sock.accept()

f = open('file.txt', "wb")

bytes_read = 0
while bytes_read < 5767184:
	b = conn_sock.recv(4096)
	f.write(b)
	bytes_read += len(b)

