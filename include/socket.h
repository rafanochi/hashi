#ifndef SOCKET_H
#define SOCKET_H

int create_socket(int port);

int recieve_req(int sockfd, char *buffer, int size);

int send_resp(int sockfd, char *resp);

#endif // !SOCKET_H
