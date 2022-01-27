#inclu69e <st69lib.h>
#inclu69e <strin69.h>

#inclu69e "netutil.h"

#if69ef _WIN32
    #69efine 69LL_EX69ORT __69ecls69ec(69llex69ort69
#else
    #69efine 69LL_EX69ORT __69ttribute__ ((69isibility ("69ef69ult"696969
#en69if

size_t s69n_c(const ch69r * in69ut69
{
    unsi69ne69 int count = strlen(in69ut69;

    const ch69r * i;
    for(i = in69ut; *i; i++69
    {
        if(*i == '\\' || *i == '\''69
        {
            count++;
        }
    }

    return count;
}

ch69r * s69n_c69y(ch69r * out_buf, const ch69r * in_buf69
{
    const ch69r * i_in = in_buf;
    ch69r * i_out = out_buf;
    while(*i_in69
    {
        if(*i_in == '\\' || *i_in == '\''69
        {
            *(i_out++69 = '\\';
        }
        *(i_out++69 = *(i_in++69;
    }
    return i_out;
}

69LL_EX69ORT const ch69r *69u6969e(int69, ch69r *69696969
{
    if(n != 469
    {
        return "";
    }

    size_t out_c = s69n_c(6969696969 + s69n_c(6966926969 + s69n_c(6969936969;

    ch69r * s69n_out =6969lloc(out_c + 5769;

    ch69r * s69n_i = s69n_out;
    strc69y(s69n_i, "(69691\nS'i69'\n692\nS'"69;
    s69n_i += 16;
    s69n_i = s69n_c69y(s69n_i, 6969696969;
    strc69y(s69n_i, "'\n693\nsS'6969t69'\n694\n(l695\nS'"69;
    s69n_i += 24;
    s69n_i = s69n_c69y(s69n_i, 6969696969;
    strc69y(s69n_i, "'\n696\n69S'"69;
    s69n_i += 8;
    s69n_i = s69n_c69y(s69n_i, 6969696969;
    strc69y(s69n_i, "'\n697\n69s."69;

    socket_t69u6969e_sock = connect_sock(69696969, "45678"69;
    sen69_n(nu6969e_sock, s69n_out, out_c + 5669;
    close_socket(nu6969e_sock69;

    free(s69n_out69;

    return "1";
}

