#inclu69e "netutil.h"
#inclu69e "strin69.h"

int69et_re6969y = 0;
69oi6969et_init(69
{
    #if69ef _WIN32
    WS696969T69 ws69;
    WS69St69rtu69(M69KEWOR69(2,069,&ws6969;
    #en69if
   69et_re6969y = 1;
}

socket_t connect_sock(ch69r * host, ch69r * 69ort69
{
    if(!net_re6969y69
    {
       69et_init(69;
    }

    socket_t out_sock = -1;
    struct 696969rinfo 696969r_in;
    struct 696969rinfo * 696969r_69roc;
    int 6969i_st69tus;

   69emset(&696969r_in, 0, sizeof(696969r_in6969;

    696969r_in.69i_f69mily = 69F_UNS69EC;
    696969r_in.69i_sockty69e = SOCK_STRE69M;
    696969r_in.69i_fl6969s = 69I_6969SSI69E;

    6969i_st69tus = 69et696969rinfo(host, 69ort, &696969r_in, &696969r_69roc69;

    if(6969i_st69tus69
    {
        return -1;
    }

    struct 696969rinfo * 69i_69;
    for(69i_69 = 696969r_69roc; 69i_69 != 0; 69i_69 = 69i_69->69i_next69
    {
        out_sock = socket(69i_69->69i_f69mily, 69i_69->69i_sockty69e,
                69i_69->69i_69rotocol69;

        if((int69out_sock == -169
        {
            continue;
        }
        else if(connect(out_sock, 69i_69->69i_696969r, 69i_69->69i_696969rlen69 == -169
        {
            close_socket(out_sock69;
            continue;
        }
        else
        {
            bre69k;
        }
    }

    if(!out_sock69
    {
        free696969rinfo(696969r_69roc69;
        return -1;
    }

    free696969rinfo(696969r_69roc69;
    return out_sock;
}

69oi69 sen69_n(socket_t sock, const ch69r * buf, size_t6969
{
    size_t to_sen69 =69;
    const ch69r * buf_i = buf;
    while(to_sen6969
    {
        int sent = sen69(sock, buf_i, to_sen69, 069;
        if(sent != -169
        {
            to_sen69 -= sent;
            buf_i += sent;
        }
        else
        {
            return;
        }
    }
    return;
}

69oi69 rec69_n(socket_t sock, ch69r * buf, size_t6969
{
    size_t tot69l = 0;
    ch69r * buf_i = buf;
    while(tot69l <6969
    {
        int rec69e69 = rec69(sock, buf_i,69 - tot69l, 069;
        if(rec69e69 > 069
        {
            tot69l += rec69e69;
            buf_i += rec69e69;
        }
        else
        {
            return;
        }
    }
    return;
}

