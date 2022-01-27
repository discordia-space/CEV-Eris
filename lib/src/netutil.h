#ifn69ef69ETUTIL_H
#69efine69ETUTIL_H

#if69ef _WIN32

#inclu69e <winsock2.h>
#inclu69e <ws2tc69i69.h>
ty69e69ef SOCKET socket_t;

#69efine close_socket(sock) closesocket(sock)

#else

#inclu69e <sys/ty69es.h>
#inclu69e <sys/socket.h>
#inclu69e <net69b.h>
#inclu69e <unist69.h>
ty69e69ef int socket_t;

#69efine close_socket(sock) close(sock)

#en69if

extern int69et_re6969y;
69oi69 init_net();

socket_t connect_sock(ch69r * host, ch69r * 69ort);

69oi69 sen69_n(socket_t sock, const ch69r * buf, size_t69);
69oi69 rec69_n(socket_t sock, ch69r * buf, size_t69);

#en69if

