import socket

sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM) 

sock.connect(('10.10.2.100', 4000))

f = open('file.txt', "rb")

b = f.read(4096)

bytes_sent = 0

while (b):
    sock.sendall(b)
    bytes_sent += 4096
    print("Sent %d out of 5767184 bytes" % min(bytes_sent, 5767184))
    b = f.read(4096)

sock.shutdown(socket.SHUT_RDWR)

f.close()
