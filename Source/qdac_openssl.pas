unit qdac_openssl;

{ ==============================================================================|
  | Project : Ararat Synapse                                       | 003.004.001 |
  |==============================================================================|
  | Content: SSL support by OpenSSL                                              |
  |==============================================================================|
  | Copyright (c)1999-2005, Lukas Gebauer                                        |
  | All rights reserved.                                                         |
  |                                                                              |
  | Redistribution and use in source and binary forms, with or without           |
  | modification, are permitted provided that the following conditions are met:  |
  |                                                                              |
  | Redistributions of source code must retain the above copyright notice, this  |
  | list of conditions and the following disclaimer.                             |
  |                                                                              |
  | Redistributions in binary form must reproduce the above copyright notice,    |
  | this list of conditions and the following disclaimer in the documentation    |
  | and/or other materials provided with the distribution.                       |
  |                                                                              |
  | Neither the name of Lukas Gebauer nor the names of its contributors may      |
  | be used to endorse or promote products derived from this software without    |
  | specific prior written permission.                                           |
  |                                                                              |
  | THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"  |
  | AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE    |
  | IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE   |
  | ARE DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR  |
  | ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL       |
  | DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR   |
  | SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER   |
  | CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT           |
  | LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY    |
  | OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH  |
  | DAMAGE.                                                                      |
  |==============================================================================|
  | The Initial Developer of the Original Code is Lukas Gebauer (Czech Republic).|
  | Portions created by Lukas Gebauer are Copyright (c)2002-2005.                |
  | All Rights Reserved.                                                         |
  |==============================================================================|
  | Contributor(s):                                                              |
  |==============================================================================|
  | FreePascal basic cleanup (original worked too): Ales Katona                  |
  | WARNING: due to reliance on some units, I have removed the ThreadLocks init  |
  |          if need be, it should be re-added, or handled by the                |
  |           OS threading init somehow                                          |
  |                                                                              |
  | 2010 - Felipe Monteiro de Carvalho - Added RAND functios                     |
  |==============================================================================|
  |  2010-08-24 add fuctions to hash strings based on rsa key PEM format         |
  |             change some type declarationc on x509 type                       |
  |             work is not complete.                                            |
  |             Work made by Alberto Brito based on unit from                    |
  |             Marco Ferrante                                                   |
  |                                                                              |
  |                                                                              |
  |                                                                              |
  |==============================================================================|
  | History: see HISTORY.HTM from distribution package                           |
  |          (Found at URL: http://www.ararat.cz/synapse/)                       |
  |============================================================================== }

{
  Special thanks to Gregor Ibic <gregor.ibic@intelicom.si>
  (Intelicom d.o.o., http://www.intelicom.si)
  for good inspiration about begin with SSL programming.
}

{$H+}
{ :@abstract(OpenSSL support)

  This unit is Pascal interface to OpenSSL library (used by @link(ssl_openssl) unit).
  OpenSSL is loaded dynamicly on-demand. If this library is not found in system,
  requested OpenSSL function just return errorcode.
}

{
  YangYxd �޸ģ������ Delphi �еı�������
}

interface

uses
  qdac_openssl_dynlibs, Windows, SysUtils;

const
  LineEnding = sLineBreak;
  DLLSSLNames: array [0 .. 2] of String = ('libssl-1_1.dll', 'ssleay32.dll', 'libssl32.dll');
  DLLUtilNames: array [0 .. 1] of String = ('libcrypto-1_1.dll', 'libeay32.dll');

const
  // EVP.h Constants

  EVP_MAX_MD_SIZE = 64; // * longest known is SHA512 */
  EVP_MAX_KEY_LENGTH = 32;
  EVP_MAX_IV_LENGTH = 16;
  EVP_MAX_BLOCK_LENGTH = 32;

  SHA_DIGEST_LENGTH = 20;

type
  { ctype }
  StringA = AnsiString;
  PCharA = PAnsiChar;
  PCharW = PWideChar;
  qword = int64; // Keep h2pas "uses ctypes" headers working with delphi.
  ptruint = cardinal;
  pptruint = ^ptruint;

  { the following type definitions are compiler dependant }
  { and system dependant }

  cint8 = shortint;
  pcint8 = ^cint8;
  cuint8 = byte;
  pcuint8 = ^cuint8;
  cchar = cint8;
  pcchar = ^cchar;
  cschar = cint8;
  pcschar = ^cschar;
  cuchar = cuint8;
  pcuchar = ^cuchar;

  cint16 = smallint;
  pcint16 = ^cint16;
  cuint16 = word;
  pcuint16 = ^cuint16;
  cshort = cint16;
  pcshort = ^cshort;
  csshort = cint16;
  pcsshort = ^csshort;
  cushort = cuint16;
  pcushort = ^cushort;

  cint32 = longint;
  pcint32 = ^cint32;
  cuint32 = longword;
  pcuint32 = ^cuint32;

  cint64 = int64;
  pcint64 = ^cint64;
  cuint64 = qword;
  pcuint64 = ^cuint64;
  clonglong = cint64;
  pclonglong = ^clonglong;
  cslonglong = cint64;
  pcslonglong = ^cslonglong;
  culonglong = cuint64;
  pculonglong = ^culonglong;

  cbool = longbool;
  pcbool = ^cbool;

{$IF defined(cpu64) and not(defined(win64) and defined(cpux86_64))}
  cint = cint32;
  pcint = ^cint; { minimum range is : 32-bit }
  csint = cint32;
  pcsint = ^csint; { minimum range is : 32-bit }
  cuint = cuint32;
  pcuint = ^cuint; { minimum range is : 32-bit }
  clong = int64;
  pclong = ^clong;
  cslong = int64;
  pcslong = ^cslong;
  culong = qword;
  pculong = ^culong;
{$ELSEIF defined(cpu16)}
  { 16-bit int sizes checked against Borland C++ 3.1 and Open Watcom 1.9 }
  cint = cint16;
  pcint = ^cint;
  csint = cint16;
  pcsint = ^csint;
  cuint = cuint16;
  pcuint = ^cuint;
  clong = longint;
  pclong = ^clong;
  cslong = longint;
  pcslong = ^cslong;
  culong = cardinal;
  pculong = ^culong;
{$ELSE}
  cint = cint32;
  pcint = ^cint; { minimum range is : 32-bit }
  csint = cint32;
  pcsint = ^csint; { minimum range is : 32-bit }
  cuint = cuint32;
  pcuint = ^cuint; { minimum range is : 32-bit }
  clong = longint;
  pclong = ^clong;
  cslong = longint;
  pcslong = ^cslong;
  culong = cardinal;
  pculong = ^culong;
{$IFEND}
  csigned = cint;
  pcsigned = ^csigned;
  cunsigned = cuint;
  pcunsigned = ^cunsigned;

  csize_t = ptruint;
  pcsize_t = pptruint;

  // Kylix compat types
  u_long = culong;
  u_short = cushort;
  coff_t = clong;

  cfloat = single;
  pcfloat = ^cfloat;
  cdouble = double;
  pcdouble = ^cdouble;

type
  SslPtr = Pointer;
  PSslPtr = ^SslPtr;
  PSSL_CTX = SslPtr;
  PSSL = SslPtr;
  PSSL_METHOD = SslPtr;
  { PX509 = SslPtr; }
  { PX509_NAME = SslPtr; }
  PEVP_MD = SslPtr;
  PBIO_METHOD = SslPtr;
  PBIO = SslPtr;
  { EVP_PKEY = SslPtr; }
  PRSA = SslPtr;
  PASN1_UTCTIME = SslPtr;
  PASN1_INTEGER = SslPtr;

  PDH = Pointer;
  PSTACK_OFX509 = Pointer;

  X509_NAME = record
    entries: Pointer;
    modified: integer;
    bytes: Pointer;
    hash: cardinal;
  end;

  PX509_NAME = ^X509_NAME;
  PDN = ^X509_NAME;

  ASN1_STRING = record
    length: integer;
    asn1_type: integer;
    data: Pointer;
    flags: longint;
  end;

  PASN1_STRING = ^ASN1_STRING;
  PASN1_TIME = PASN1_STRING;

  X509_VAL = record
    notBefore: PASN1_TIME;
    notAfter: PASN1_TIME;
  end;

  PX509_VAL = ^X509_VAL;

  X509_CINF = record
    version: Pointer;
    serialNumber: Pointer;
    signature: Pointer;
    issuer: Pointer;
    validity: PX509_VAL;
    subject: Pointer;
    key: Pointer;
    issuerUID: Pointer;
    subjectUID: Pointer;
    extensions: Pointer;
  end;

  PX509_CINF = ^X509_CINF;

  CRYPTO_EX_DATA = record
    sk: Pointer;
    dummy: integer;
  end;

  X509 = record
    cert_info: PX509_CINF;
    sig_alg: Pointer; // ^X509_ALGOR
    signature: Pointer; // ^ASN1_BIT_STRING
    valid: integer;
    references: integer;
    name: PCharA;
    ex_data: CRYPTO_EX_DATA;
    ex_pathlen: integer;
    ex_flags: integer;
    ex_kusage: integer;
    ex_xkusage: integer;
    ex_nscert: integer;
    skid: Pointer; // ^ASN1_OCTET_STRING
    akid: Pointer; // ?
    sha1_hash: array [0 .. SHA_DIGEST_LENGTH - 1] of char;
    aux: Pointer; // ^X509_CERT_AUX
  end;

  pX509 = ^X509;

  DSA = record
    pad: integer;
    version: integer;
    write_params: integer;
    p: Pointer;
    q: Pointer;
    g: Pointer;
    pub_key: Pointer;
    priv_key: Pointer;
    kinv: Pointer;
    r: Pointer;
    flags: integer;
    method_mont_p: PCharA;
    references: integer;

    ex_data: record
      sk: Pointer;
      dummy: integer;
    end;

    meth: Pointer;
  end;

  pDSA = ^DSA;

  EVP_PKEY_PKEY = record
    case integer of
      0:
        (ptr: PCharA);
      1:
        (rsa: PRSA);
      2:
        (DSA: pDSA);
      3:
        (dh: PDH);
  end;

  EVP_PKEY = record
    ktype: integer;
    save_type: integer;
    references: integer;
    pkey: EVP_PKEY_PKEY;
    save_parameters: integer;
    attributes: PSTACK_OFX509;
  end;

  PEVP_PKEY = ^EVP_PKEY;
  PPEVP_PKEY = ^PEVP_PKEY;

  PPRSA = ^PRSA;
  PASN1_cInt = SslPtr;
  PPasswdCb = SslPtr;
  PFunction = procedure;
  DES_cblock = array [0 .. 7] of byte;
  PDES_cblock = ^DES_cblock;

  des_ks_struct = packed record
    ks: DES_cblock;
    weak_key: cint;
  end;

  des_key_schedule = array [1 .. 16] of des_ks_struct;

  MD2_CTX = record
    num: integer;
    data: array [0 .. 15] of byte;
    cksm: array [0 .. 15] of cardinal;
    state: array [0 .. 15] of cardinal;
  end;

  MD4_CTX = record
    A, B, C, D: cardinal;
    Nl, Nh: cardinal;
    data: array [0 .. 15] of cardinal;
    num: integer;
  end;

  MD5_CTX = record
    A, B, C, D: cardinal;
    Nl, Nh: cardinal;
    data: array [0 .. 15] of cardinal;
    num: integer;
  end;

  RIPEMD160_CTX = record
    A, B, C, D, E: cardinal;
    Nl, Nh: cardinal;
    data: array [0 .. 15] of cardinal;
    num: integer;
  end;

  SHA_CTX = record
    h0, h1, h2, h3, h4: cardinal;
    Nl, Nh: cardinal;
    data: array [0 .. 16] of cardinal;
    num: integer;
  end;

  MDC2_CTX = record
    num: integer;
    data: array [0 .. 7] of byte;
    h, hh: DES_cblock;
    pad_type: integer;
  end;

  // Rand
  RAND_METHOD = record
  end;

  PRAND_METHOD = ^RAND_METHOD;

  // RSA
  PENGINE = Pointer;
  PBIGNUM = Pointer;
  PBN_GENCB = Pointer;
  PBN_MONT_CTX = Pointer;
  PBN_CTX = Pointer;
  PPByte = ^PByte;

  Trsa_pub_enc = function(flen: cint; const from_, to_: PByte; arsa: PRSA; padding: cint): cint;
  Trsa_pub_dec = function(flen: cint; const from_, to_: PByte; arsa: PRSA; padding: cint): cint;
  Trsa_priv_enc = function(flen: cint; const from_, to_: PByte; arsa: PRSA; padding: cint): cint;
  Trsa_priv_dec = function(flen: cint; const from_, to_: PByte; arsa: PRSA; padding: cint): cint;
  Trsa_mod_exp = function(r0: PBIGNUM; const l: PBIGNUM; arsa: PRSA; ctx: PBN_CTX): cint;
  Tbn_mod_exp = function(r: PBIGNUM; const A, p, m: PBIGNUM; arsa: PRSA; ctx: PBN_CTX; m_ctx: PBN_MONT_CTX): cint;
  Tinit = function(arsa: PRSA): cint;
  Tfinish = function(arsa: PRSA): cint;
  Trsa_sign = function(type_: cint; const m: PByte; m_length: cuint; sigret: PByte; siglen: pcuint; arsa: PRSA): cint;
  Trsa_verify = function(dtype: cint; const m: PByte; m_length: cuint; const sigbuf: PByte; siglen: cuint; arsa: PRSA): cint;
  Trsa_keygen = function(arsa: PRSA; bits: cint; E: PBIGNUM; cb: PBN_GENCB): cint;

  RSA_METHOD = record
    name: PCharA;
    rsa_pub_enc: Trsa_pub_enc;
    rsa_pub_dec: Trsa_pub_dec;
    rsa_priv_enc: Trsa_priv_enc;
    rsa_priv_dec: Trsa_priv_dec;
    rsa_mod_exp: Trsa_mod_exp; { Can be null }
    bn_mod_exp: Tbn_mod_exp; { Can be null }
    init: Tinit; { called at new }
    finish: Tfinish; { called at free }
    flags: cint; { RSA_METHOD_FLAG_* things }
    app_data: PCharA; { may be needed! }
    { New sign and verify functions: some libraries don't allow arbitrary data
      * to be signed/verified: this allows them to be used. Note: for this to work
      * the RSA_public_decrypt() and RSA_private_encrypt() should *NOT* be used
      * RSA_sign(), RSA_verify() should be used instead. Note: for backwards
      * compatibility this functionality is only enabled if the RSA_FLAG_SIGN_VER
      * option is set in 'flags'.
    }
    rsa_sign: Trsa_sign;
    rsa_verify: Trsa_verify;
    { If this callback is NULL, the builtin software RSA key-gen will be used. This
      * is for behavioural compatibility whilst the code gets rewired, but one day
      * it would be nice to assume there are no such things as "builtin software"
      * implementations. }
    rsa_keygen: Trsa_keygen;
  end;

  PRSA_METHOD = ^RSA_METHOD;

  // EVP

  EVP_MD_CTX = record
    digest: PEVP_MD;
    case integer of
      0:
        (base: array [0 .. 3] of byte);
      1:
        (md2: MD2_CTX);
      8:
        (md4: MD4_CTX);
      2:
        (md5: MD5_CTX);
      16:
        (ripemd160: RIPEMD160_CTX);
      4:
        (sha: SHA_CTX);
      32:
        (mdc2: MDC2_CTX);
  end;

  PEVP_MD_CTX = ^EVP_MD_CTX;

  PEVP_CIPHER_CTX = ^EVP_CIPHER_CTX;

  PASN1_TYPE = Pointer;

  EVP_CIPHER_INIT_FUNC = function(ctx: PEVP_CIPHER_CTX; const key, iv: PByte; enc: cint): cint; cdecl;
  EVP_CIPHER_DO_CIPHER_FUNC = function(ctx: PEVP_CIPHER_CTX; out_data: PByte; const in_data: PByte; inl: csize_t): cint; cdecl;
  EVP_CIPHER_CLEANUP_FUNC = function(ctx: PEVP_CIPHER_CTX): cint; cdecl;
  EVP_CIPHER_SET_ASN1_PARAMETERS_FUNC = function(ctx: PEVP_CIPHER_CTX; asn1_type: PASN1_TYPE): cint; cdecl;
  EVP_CIPHER_GET_ASN1_PARAMETERS_FUNC = function(ctx: PEVP_CIPHER_CTX; asn1_type: PASN1_TYPE): cint; cdecl;
  EVP_CIPHER_CTRL_FUNC = function(ctx: PEVP_CIPHER_CTX; type_, arg: cint; ptr: Pointer): cint; cdecl;

  EVP_CIPHER = record // Updated with EVP.h from OpenSSL 1.0.0
    nid: cint;
    block_size: cint;
    key_len: cint; // * Default value for variable length ciphers */
    iv_len: cint;
    flags: culong; // * Various flags */
    init: EVP_CIPHER_INIT_FUNC; // * init key */
    do_cipher: EVP_CIPHER_DO_CIPHER_FUNC; // * encrypt/decrypt data */
    cleanup: EVP_CIPHER_CLEANUP_FUNC; // * cleanup ctx */
    ctx_size: cint; // * how big ctx->cipher_data needs to be */
    set_asn1_parameters: EVP_CIPHER_SET_ASN1_PARAMETERS_FUNC; // * Populate a ASN1_TYPE with parameters */
    get_asn1_parameters: EVP_CIPHER_GET_ASN1_PARAMETERS_FUNC; // * Get parameters from a ASN1_TYPE */
    ctrl: EVP_CIPHER_CTRL_FUNC; // * Miscellaneous operations */
    app_data: Pointer; // * Application data */
  end;

  PEVP_CIPHER = ^EVP_CIPHER;

  EVP_CIPHER_CTX = record // Updated with EVP.h from OpenSSL 1.0.0
    cipher: PEVP_CIPHER;
    engine: PENGINE; // * functional reference if 'cipher' is ENGINE-provided */
    encrypt: cint; // * encrypt or decrypt */
    buf_len: cint; // * number we have left */

    oiv: array [0 .. EVP_MAX_IV_LENGTH - 1] of byte; // * original iv */
    iv: array [0 .. EVP_MAX_IV_LENGTH - 1] of byte; // * working iv */
    buf: array [0 .. EVP_MAX_IV_LENGTH - 1] of byte; // * saved partial block */
    num: cint; // * used by cfb/ofb mode */

    app_data: Pointer; // * application stuff */
    key_len: cint; // * May change for variable length cipher */
    flags: culong; // * Various flags */
    cipher_data: Pointer; // * per EVP data */
    final_used: cint;
    block_mask: cint;
    final: array [0 .. EVP_MAX_BLOCK_LENGTH - 1] of byte; // * possible final block */
    final2: array [0 .. $1FFF] of byte; // Extra storage space, otherwise an access violation
    // in the OpenSSL library will occur
  end;

  // PEM

  Ppem_password_cb = Pointer;

const
  SSL_ERROR_NONE = 0;
  SSL_ERROR_SSL = 1;
  SSL_ERROR_WANT_READ = 2;
  SSL_ERROR_WANT_WRITE = 3;
  SSL_ERROR_WANT_X509_LOOKUP = 4;
  SSL_ERROR_SYSCALL = 5; // look at error stack/return value/errno
  SSL_ERROR_ZERO_RETURN = 6;
  SSL_ERROR_WANT_CONNECT = 7;
  SSL_ERROR_WANT_ACCEPT = 8;

  SSL_CTRL_NEED_TMP_RSA = 1;
  SSL_CTRL_SET_TMP_RSA = 2;
  SSL_CTRL_SET_TMP_DH = 3;
  SSL_CTRL_SET_TMP_ECDH = 4;
  SSL_CTRL_SET_TMP_RSA_CB = 5;
  SSL_CTRL_SET_TMP_DH_CB = 6;
  SSL_CTRL_SET_TMP_ECDH_CB = 7;
  SSL_CTRL_GET_SESSION_REUSED = 8;
  SSL_CTRL_GET_CLIENT_CERT_REQUEST = 9;
  SSL_CTRL_GET_NUM_RENEGOTIATIONS = 10;
  SSL_CTRL_CLEAR_NUM_RENEGOTIATIONS = 11;
  SSL_CTRL_GET_TOTAL_RENEGOTIATIONS = 12;
  SSL_CTRL_GET_FLAGS = 13;
  SSL_CTRL_EXTRA_CHAIN_CERT = 14;
  SSL_CTRL_SET_MSG_CALLBACK = 15;
  SSL_CTRL_SET_MSG_CALLBACK_ARG = 16;
  SSL_CTRL_SET_MTU = 17;
  SSL_CTRL_SESS_NUMBER = 20;
  SSL_CTRL_SESS_CONNECT = 21;
  SSL_CTRL_SESS_CONNECT_GOOD = 22;
  SSL_CTRL_SESS_CONNECT_RENEGOTIATE = 23;
  SSL_CTRL_SESS_ACCEPT = 24;
  SSL_CTRL_SESS_ACCEPT_GOOD = 25;
  SSL_CTRL_SESS_ACCEPT_RENEGOTIATE = 26;
  SSL_CTRL_SESS_HIT = 27;
  SSL_CTRL_SESS_CB_HIT = 28;
  SSL_CTRL_SESS_MISSES = 29;
  SSL_CTRL_SESS_TIMEOUTS = 30;
  SSL_CTRL_SESS_CACHE_FULL = 31;
  SSL_CTRL_OPTIONS = 32;
  SSL_CTRL_MODE = 33;
  SSL_CTRL_GET_READ_AHEAD = 40;
  SSL_CTRL_SET_READ_AHEAD = 41;
  SSL_CTRL_SET_SESS_CACHE_SIZE = 42;
  SSL_CTRL_GET_SESS_CACHE_SIZE = 43;
  SSL_CTRL_SET_SESS_CACHE_MODE = 44;
  SSL_CTRL_GET_SESS_CACHE_MODE = 45;
  SSL_CTRL_GET_MAX_CERT_LIST = 50;
  SSL_CTRL_SET_MAX_CERT_LIST = 51;
  SSL_CTRL_SET_MAX_SEND_FRAGMENT = 52;
  SSL_CTRL_SET_TLSEXT_SERVERNAME_CB = 53;
  SSL_CTRL_SET_TLSEXT_SERVERNAME_ARG = 54;
  SSL_CTRL_SET_TLSEXT_HOSTNAME = 55;
  SSL_CTRL_SET_TLSEXT_DEBUG_CB = 56;
  SSL_CTRL_SET_TLSEXT_DEBUG_ARG = 57;
  SSL_CTRL_GET_TLSEXT_TICKET_KEYS = 58;
  SSL_CTRL_SET_TLSEXT_TICKET_KEYS = 59;
  SSL_CTRL_SET_TLSEXT_OPAQUE_PRF_INPUT = 60;
  SSL_CTRL_SET_TLSEXT_OPAQUE_PRF_INPUT_CB = 61;
  SSL_CTRL_SET_TLSEXT_OPAQUE_PRF_INPUT_CB_ARG = 62;
  SSL_CTRL_SET_TLSEXT_STATUS_REQ_CB = 63;
  SSL_CTRL_SET_TLSEXT_STATUS_REQ_CB_ARG = 64;
  SSL_CTRL_SET_TLSEXT_STATUS_REQ_TYPE = 65;
  SSL_CTRL_GET_TLSEXT_STATUS_REQ_EXTS = 66;
  SSL_CTRL_SET_TLSEXT_STATUS_REQ_EXTS = 67;
  SSL_CTRL_GET_TLSEXT_STATUS_REQ_IDS = 68;
  SSL_CTRL_SET_TLSEXT_STATUS_REQ_IDS = 69;
  SSL_CTRL_GET_TLSEXT_STATUS_REQ_OCSP_RESP = 70;
  SSL_CTRL_SET_TLSEXT_STATUS_REQ_OCSP_RESP = 71;
  SSL_CTRL_SET_TLSEXT_TICKET_KEY_CB = 72;
  SSL_CTRL_SET_TLS_EXT_SRP_USERNAME_CB = 75;
  SSL_CTRL_SET_SRP_VERIFY_PARAM_CB = 76;
  SSL_CTRL_SET_SRP_GIVE_CLIENT_PWD_CB = 77;
  SSL_CTRL_SET_SRP_ARG = 78;
  SSL_CTRL_SET_TLS_EXT_SRP_USERNAME = 79;
  SSL_CTRL_SET_TLS_EXT_SRP_STRENGTH = 80;
  SSL_CTRL_SET_TLS_EXT_SRP_PASSWORD = 81;
  SSL_CTRL_GET_EXTRA_CHAIN_CERTS = 82;
  SSL_CTRL_CLEAR_EXTRA_CHAIN_CERTS = 83;
  SSL_CTRL_TLS_EXT_SEND_HEARTBEAT = 85;
  SSL_CTRL_GET_TLS_EXT_HEARTBEAT_PENDING = 86;
  SSL_CTRL_SET_TLS_EXT_HEARTBEAT_NO_REQUESTS = 87;
  // Some missing values ?

  DTLS_CTRL_GET_TIMEOUT = 73;
  DTLS_CTRL_HANDLE_TIMEOUT = 74;
  DTLS_CTRL_LISTEN = 75;
  SSL_CTRL_GET_RI_SUPPORT = 76;
  SSL_CTRL_CLEAR_OPTIONS = 77;
  SSL_CTRL_CLEAR_MODE = 78;

  TLSEXT_NAMETYPE_host_name = 0;

  SSL_MODE_ENABLE_PARTIAL_WRITE = 1;
  SSL_MODE_ACCEPT_MOVING_WRITE_BUFFER = 2;
  SSL_MODE_AUTO_RETRY = 4;
  SSL_MODE_NO_AUTO_CHAIN = 8;

  SSL_OP_NO_SSLv2 = $01000000;
  SSL_OP_NO_SSLv3 = $02000000;
  SSL_OP_NO_TLSv1 = $04000000;
  SSL_OP_ALL = $000FFFFF;
  SSL_VERIFY_NONE = $00;
  SSL_VERIFY_PEER = $01;

  OPENSSL_DES_DECRYPT = 0;
  OPENSSL_DES_ENCRYPT = 1;

  X509_V_OK = 0;
  X509_V_ILLEGAL = 1;
  X509_V_ERR_UNABLE_TO_GET_ISSUER_CERT = 2;
  X509_V_ERR_UNABLE_TO_GET_CRL = 3;
  X509_V_ERR_UNABLE_TO_DECRYPT_CERT_SIGNATURE = 4;
  X509_V_ERR_UNABLE_TO_DECRYPT_CRL_SIGNATURE = 5;
  X509_V_ERR_UNABLE_TO_DECODE_ISSUER_PUBLIC_KEY = 6;
  X509_V_ERR_CERT_SIGNATURE_FAILURE = 7;
  X509_V_ERR_CRL_SIGNATURE_FAILURE = 8;
  X509_V_ERR_CERT_NOT_YET_VALID = 9;
  X509_V_ERR_CERT_HAS_EXPIRED = 10;
  X509_V_ERR_CRL_NOT_YET_VALID = 11;
  X509_V_ERR_CRL_HAS_EXPIRED = 12;
  X509_V_ERR_ERROR_IN_CERT_NOT_BEFORE_FIELD = 13;
  X509_V_ERR_ERROR_IN_CERT_NOT_AFTER_FIELD = 14;
  X509_V_ERR_ERROR_IN_CRL_LAST_UPDATE_FIELD = 15;
  X509_V_ERR_ERROR_IN_CRL_NEXT_UPDATE_FIELD = 16;
  X509_V_ERR_OUT_OF_MEM = 17;
  X509_V_ERR_DEPTH_ZERO_SELF_SIGNED_CERT = 18;
  X509_V_ERR_SELF_SIGNED_CERT_IN_CHAIN = 19;
  X509_V_ERR_UNABLE_TO_GET_ISSUER_CERT_LOCALLY = 20;
  X509_V_ERR_UNABLE_TO_VERIFY_LEAF_SIGNATURE = 21;
  X509_V_ERR_CERT_CHAIN_TOO_LONG = 22;
  X509_V_ERR_CERT_REVOKED = 23;
  X509_V_ERR_INVALID_CA = 24;
  X509_V_ERR_PATH_LENGTH_EXCEEDED = 25;
  X509_V_ERR_INVALID_PURPOSE = 26;
  X509_V_ERR_CERT_UNTRUSTED = 27;
  X509_V_ERR_CERT_REJECTED = 28;
  // These are 'informational' when looking for issuer cert
  X509_V_ERR_SUBJECT_ISSUER_MISMATCH = 29;
  X509_V_ERR_AKID_SKID_MISMATCH = 30;
  X509_V_ERR_AKID_ISSUER_SERIAL_MISMATCH = 31;
  X509_V_ERR_KEYUSAGE_NO_CERTSIGN = 32;
  X509_V_ERR_UNABLE_TO_GET_CRL_ISSUER = 33;
  X509_V_ERR_UNHANDLED_CRITICAL_EXTENSION = 34;
  // The application is not happy
  X509_V_ERR_APPLICATION_VERIFICATION = 50;

  SSL_FILETYPE_ASN1 = 2;
  SSL_FILETYPE_PEM = 1;
  EVP_PKEY_RSA = 6;

  // RSA
  RSA_PKCS1_PADDING = 1;
  RSA_SSLV23_PADDING = 2;
  RSA_NO_PADDING = 3;
  RSA_PKCS1_OAEP_PADDING = 4;

  // BIO

  BIO_NOCLOSE = $00;
  BIO_CLOSE = $01;

  // * modifiers */
  BIO_FP_READ = $02;
  BIO_FP_WRITE = $04;
  BIO_FP_APPEND = $08;
  BIO_FP_TEXT = $10;

  BIO_C_SET_CONNECT = 100;
  BIO_C_DO_STATE_MACHINE = 101;
  BIO_C_SET_NBIO = 102;
  BIO_C_SET_PROXY_PARAM = 103;
  BIO_C_SET_FD = 104;
  BIO_C_GET_FD = 105;
  BIO_C_SET_FILE_PTR = 106;
  BIO_C_GET_FILE_PTR = 107;
  BIO_C_SET_FILENAME = 108;
  BIO_C_SET_SSL = 109;
  BIO_C_GET_SSL = 110;
  BIO_C_SET_MD = 111;
  BIO_C_GET_MD = 112;
  BIO_C_GET_CIPHER_STATUS = 113;
  BIO_C_SET_BUF_MEM = 114;
  BIO_C_GET_BUF_MEM_PTR = 115;
  BIO_C_GET_BUFF_NUM_LINES = 116;
  BIO_C_SET_BUFF_SIZE = 117;
  BIO_C_SET_ACCEPT = 118;
  BIO_C_SSL_MODE = 119;
  BIO_C_GET_MD_CTX = 120;
  BIO_C_GET_PROXY_PARAM = 121;
  BIO_C_SET_BUFF_READ_DATA = 122; // data to read first */
  BIO_C_GET_CONNECT = 123;
  BIO_C_GET_ACCEPT = 124;
  BIO_C_SET_SSL_RENEGOTIATE_BYTES = 125;
  BIO_C_GET_SSL_NUM_RENEGOTIATES = 126;
  BIO_C_SET_SSL_RENEGOTIATE_TIMEOUT = 127;
  BIO_C_FILE_SEEK = 128;
  BIO_C_GET_CIPHER_CTX = 129;
  BIO_C_SET_BUF_MEM_EOF_RETURN = 130; // *return end of input value*/
  BIO_C_SET_BIND_MODE = 131;
  BIO_C_GET_BIND_MODE = 132;
  BIO_C_FILE_TELL = 133;
  BIO_C_GET_SOCKS = 134;
  BIO_C_SET_SOCKS = 135;

  BIO_C_SET_WRITE_BUF_SIZE = 136; // * for BIO_s_bio */
  BIO_C_GET_WRITE_BUF_SIZE = 137;
  BIO_C_MAKE_BIO_PAIR = 138;
  BIO_C_DESTROY_BIO_PAIR = 139;
  BIO_C_GET_WRITE_GUARANTEE = 140;
  BIO_C_GET_READ_REQUEST = 141;
  BIO_C_SHUTDOWN_WR = 142;
  BIO_C_NREAD0 = 143;
  BIO_C_NREAD = 144;
  BIO_C_NWRITE0 = 145;
  BIO_C_NWRITE = 146;
  BIO_C_RESET_READ_REQUEST = 147;
  BIO_C_SET_MD_CTX = 148;

  BIO_C_SET_PREFIX = 149;
  BIO_C_GET_PREFIX = 150;
  BIO_C_SET_SUFFIX = 151;
  BIO_C_GET_SUFFIX = 152;

  BIO_C_SET_EX_ARG = 153;
  BIO_C_GET_EX_ARG = 154;

  BIO_CTRL_RESET = 1; { opt - rewind/zero etc }
  BIO_CTRL_EOF = 2; { opt - are we at the eof }
  BIO_CTRL_INFO = 3; { opt - extra tit-bits }
  BIO_CTRL_SET = 4; { man - set the 'IO' type }
  BIO_CTRL_GET = 5; { man - get the 'IO' type }
  BIO_CTRL_PUSH = 6; { opt - internal, used to signify change }
  BIO_CTRL_POP = 7; { opt - internal, used to signify change }
  BIO_CTRL_GET_CLOSE = 8; { man - set the 'close' on free }
  BIO_CTRL_SET_CLOSE = 9; { man - set the 'close' on free }
  BIO_CTRL_PENDING = 10; { opt - is their more data buffered }
  BIO_CTRL_FLUSH = 11; { opt - 'flush' buffered output }
  BIO_CTRL_DUP = 12; { man - extra stuff for 'duped' BIO }
  BIO_CTRL_WPENDING = 13; { opt - number of bytes still to write }
  BIO_CTRL_SET_CALLBACK = 14; { opt - set callback function }
  BIO_CTRL_GET_CALLBACK = 15; { opt - set callback function }
  BIO_CTRL_SET_FILENAME = 30; { BIO_s_file special }
  BIO_CTRL_DGRAM_CONNECT = 31; { BIO dgram special }
  BIO_CTRL_DGRAM_SET_CONNECTED = 32; { allow for an externally }
  BIO_CTRL_DGRAM_SET_RECV_TIMEOUT = 33; { setsockopt, essentially }
  BIO_CTRL_DGRAM_GET_RECV_TIMEOUT = 34; { getsockopt, essentially }
  BIO_CTRL_DGRAM_SET_SEND_TIMEOUT = 35; { setsockopt, essentially }
  BIO_CTRL_DGRAM_GET_SEND_TIMEOUT = 36; { getsockopt, essentially }
  BIO_CTRL_DGRAM_GET_RECV_TIMER_EXP = 37; { flag whether the last }
  BIO_CTRL_DGRAM_GET_SEND_TIMER_EXP = 38; { I/O operation tiemd out }
  BIO_CTRL_DGRAM_MTU_DISCOVER = 39; { set DF bit on egress packets }
  BIO_CTRL_DGRAM_QUERY_MTU = 40; { as kernel for current MTU }
  BIO_CTRL_DGRAM_GET_FALLBACK_MTU = 47;
  BIO_CTRL_DGRAM_GET_MTU = 41; { get cached value for MTU }
  BIO_CTRL_DGRAM_SET_MTU = 42; { set cached value for }
  BIO_CTRL_DGRAM_MTU_EXCEEDED = 43; { check whether the MTU }
  BIO_CTRL_DGRAM_GET_PEER = 46;
  BIO_CTRL_DGRAM_SET_PEER = 44; { Destination for the data }
  BIO_CTRL_DGRAM_SET_NEXT_TIMEOUT = 45; { Next DTLS handshake timeout to }
  BIO_CTRL_DGRAM_SCTP_SET_IN_HANDSHAKE = 50;
  BIO_CTRL_DGRAM_SCTP_ADD_AUTH_KEY = 51;
  BIO_CTRL_DGRAM_SCTP_NEXT_AUTH_KEY = 52;
  BIO_CTRL_DGRAM_SCTP_AUTH_CCS_RCVD = 53;
  BIO_CTRL_DGRAM_SCTP_GET_SNDINFO = 60;
  BIO_CTRL_DGRAM_SCTP_SET_SNDINFO = 61;
  BIO_CTRL_DGRAM_SCTP_GET_RCVINFO = 62;
  BIO_CTRL_DGRAM_SCTP_SET_RCVINFO = 63;
  BIO_CTRL_DGRAM_SCTP_GET_PRINFO = 64;
  BIO_CTRL_DGRAM_SCTP_SET_PRINFO = 65;
  BIO_CTRL_DGRAM_SCTP_SAVE_SHUTDOWN = 70;

  // DES modes
  DES_ENCRYPT = 1;
  DES_DECRYPT = 0;

var
  SSLLibHandle: TLibHandle = 0;
  SSLUtilHandle: TLibHandle = 0;
  SSLLibFile: string = '';
  SSLUtilFile: string = '';

  // libssl.dll
function SslGetError(s: PSSL; ret_code: cint): cint;
function SslLibraryInit: cint;
procedure SslLoadErrorStrings;
// function SslCtxSetCipherList(arg0: PSSL_CTX; str: PCharA):cInt;
function SslCtxSetCipherList(arg0: PSSL_CTX; var str: StringA): cint;
function SslCtxNew(meth: PSSL_METHOD): PSSL_CTX;
procedure SslCtxFree(arg0: PSSL_CTX);
function SslSetFd(s: PSSL; fd: cint): cint;

function SslCtrl(ssl: PSSL; cmd: cint; larg: clong; parg: Pointer): clong;
function SslCTXCtrl(ctx: PSSL_CTX; cmd: cint; larg: clong; parg: Pointer): clong;

function SSLCTXSetMode(ctx: PSSL_CTX; mode: clong): clong;
function SSLSetMode(s: PSSL; mode: clong): clong;
function SSLCTXGetMode(ctx: PSSL_CTX): clong;
function SSLGetMode(s: PSSL): clong;

function SslMethodV2: PSSL_METHOD;
function SslMethodV3: PSSL_METHOD;
function SslMethodTLSV1: PSSL_METHOD;
function SslMethodV23: PSSL_METHOD;
function SslCtxUsePrivateKey(ctx: PSSL_CTX; pkey: SslPtr): cint;
function SslCtxUsePrivateKeyASN1(pk: cint; ctx: PSSL_CTX; D: StringA; len: clong): cint;
// function SslCtxUsePrivateKeyFile(ctx: PSSL_CTX; const _file: PCharA; _type: cInt):cInt;
function SslCtxUsePrivateKeyFile(ctx: PSSL_CTX; const _file: StringA; _type: cint): cint;
function SslCtxUseCertificate(ctx: PSSL_CTX; x: SslPtr): cint;
function SslCtxUseCertificateASN1(ctx: PSSL_CTX; len: clong; D: StringA): cint;
function SslCtxUseCertificateFile(ctx: PSSL_CTX; const _file: StringA; _type: cint): cint;
// function SslCtxUseCertificateChainFile(ctx: PSSL_CTX; const _file: PCharA):cInt;
function SslCtxUseCertificateChainFile(ctx: PSSL_CTX; const _file: StringA): cint;
function SslCtxCheckPrivateKeyFile(ctx: PSSL_CTX): cint;
procedure SslCtxSetDefaultPasswdCb(ctx: PSSL_CTX; cb: PPasswdCb);
procedure SslCtxSetDefaultPasswdCbUserdata(ctx: PSSL_CTX; u: SslPtr);
// function SslCtxLoadVerifyLocations(ctx: PSSL_CTX; const CAfile: PCharA; const CApath: PChar):cInt;
function SslCtxLoadVerifyLocations(ctx: PSSL_CTX; const CAfile: StringA; const CApath: StringA): cint;
function SslNew(ctx: PSSL_CTX): PSSL;
procedure SslFree(ssl: PSSL);
function SslAccept(ssl: PSSL): cint;
function SslConnect(ssl: PSSL): cint;
function SslShutdown(ssl: PSSL): cint;
function SslRead(ssl: PSSL; buf: SslPtr; num: cint): cint;
function SslPeek(ssl: PSSL; buf: SslPtr; num: cint): cint;
function SslWrite(ssl: PSSL; buf: SslPtr; num: cint): cint;
function SslPending(ssl: PSSL): cint;
function SslGetVersion(ssl: PSSL): StringA;
function SslGetPeerCertificate(ssl: PSSL): pX509;
procedure SslCtxSetVerify(ctx: PSSL_CTX; mode: cint; arg2: PFunction);
function SSLGetCurrentCipher(s: PSSL): SslPtr;
function SSLCipherGetName(C: SslPtr): StringA;
function SSLCipherGetBits(C: SslPtr; var alg_bits: cint): cint;
function SSLGetVerifyResult(ssl: PSSL): clong;

// libeay.dll
procedure ERR_load_crypto_strings;
function X509New: pX509;
procedure X509Free(x: pX509);
function X509NameOneline(A: PX509_NAME; var buf: StringA; size: cint): StringA;
function X509GetSubjectName(A: pX509): PX509_NAME;
function X509GetIssuerName(A: pX509): PX509_NAME;
function X509NameHash(x: PX509_NAME): culong;
// function SslX509Digest(data: PX509; _type: PEVP_MD; md: PChar; len: PcInt):cInt;
function X509Digest(data: pX509; _type: PEVP_MD; md: StringA; var len: cint): cint;
function X509print(B: PBIO; A: pX509): cint;
function X509SetVersion(x: pX509; version: cint): cint;
function X509SetPubkey(x: pX509; pkey: PEVP_PKEY): cint;
function X509SetIssuerName(x: pX509; name: PX509_NAME): cint;
function X509NameAddEntryByTxt(name: PX509_NAME; field: StringA; _type: cint; bytes: StringA; len, loc, _set: cint): cint;
function X509Sign(x: pX509; pkey: PEVP_PKEY; const md: PEVP_MD): cint;
function X509GmtimeAdj(s: PASN1_UTCTIME; adj: cint): PASN1_UTCTIME;
function X509SetNotBefore(x: pX509; tm: PASN1_UTCTIME): cint;
function X509SetNotAfter(x: pX509; tm: PASN1_UTCTIME): cint;
function X509GetSerialNumber(x: pX509): PASN1_cInt;
function EvpPkeyNew: PEVP_PKEY;
procedure EvpPkeyFree(pk: PEVP_PKEY);
function EvpPkeyAssign(pkey: PEVP_PKEY; _type: cint; key: PRSA): cint;
function EvpGetDigestByName(name: StringA): PEVP_MD;
procedure EVPcleanup;
function SSLeayversion(t: cint): StringA;
procedure ErrErrorString(E: cint; var buf: StringA; len: cint);
function ErrGetError: cint;
procedure ErrClearError;
procedure ErrFreeStrings;
procedure ErrRemoveState(pid: cint);
procedure RandScreen;
function d2iPKCS12bio(B: PBIO; Pkcs12: SslPtr): SslPtr;
function PKCS12parse(p12: SslPtr; pass: StringA; var pkey, cert, ca: SslPtr): cint;
procedure PKCS12free(p12: SslPtr);
function Asn1UtctimeNew: PASN1_UTCTIME;
procedure Asn1UtctimeFree(A: PASN1_UTCTIME);
function Asn1IntegerSet(A: PASN1_INTEGER; v: integer): integer;
function Asn1IntegerGet(A: PASN1_INTEGER): integer;
function i2dX509bio(B: PBIO; x: pX509): cint;
function i2dPrivateKeyBio(B: PBIO; pkey: PEVP_PKEY): cint;

// 3DES functions
procedure DESsetoddparity(key: DES_cblock);
function DESsetkey(key: DES_cblock; schedule: des_key_schedule): cint;
function DESsetkeychecked(key: DES_cblock; schedule: des_key_schedule): cint;
procedure DESecbencrypt(Input: DES_cblock; output: DES_cblock; ks: des_key_schedule; enc: cint);

// RAND functions

function RAND_set_rand_method(const meth: PRAND_METHOD): cint;
function RAND_get_rand_method: PRAND_METHOD;
function RAND_SSLeay: PRAND_METHOD;
procedure RAND_cleanup;
function RAND_bytes(buf: PByte; num: cint): cint;
function RAND_pseudo_bytes(buf: PByte; num: cint): cint;
procedure RAND_seed(const buf: Pointer; num: cint);
procedure RAND_add(const buf: Pointer; num: cint; entropy: cdouble);
function RAND_load_file(const file_name: PCharA; max_bytes: clong): cint;
function RAND_write_file(const file_name: PCharA): cint;
function RAND_file_name(file_name: PCharA; num: csize_t): PCharA;
function RAND_status: cint;
function RAND_query_egd_bytes(const path: PCharA; buf: PByte; bytes: cint): cint;
function RAND_egd(const path: PCharA): cint;
function RAND_egd_bytes(const path: PCharA; bytes: cint): cint;
procedure ERR_load_RAND_strings;
function RAND_poll: cint;

// RSA Functions

function RSA_new(): PRSA;
function RSA_new_method(method: PENGINE): PRSA;
function RSA_size(arsa: PRSA): cint;
// Deprecated Function: Don't use!
// For compatibility with previous versions of this file
function RsaGenerateKey(bits, E: cint; callback: PFunction; cb_arg: SslPtr): PRSA;
// New version of the previous deprecated routine
function RSA_generate_key_ex(arsa: PRSA; bits: cint; E: PBIGNUM; cb: PBN_GENCB): PRSA;
//
function RSA_check_key(arsa: PRSA): cint;
// Next 4 return -1 on error
function RSA_public_encrypt(flen: cint; from_buf, to_buf: PByte; arsa: PRSA; padding: cint): cint;
function RSA_private_encrypt(flen: cint; from_buf, to_buf: PByte; arsa: PRSA; padding: cint): cint;
function RSA_public_decrypt(flen: cint; from_buf, to_buf: PByte; arsa: PRSA; padding: cint): cint;
function RSA_private_decrypt(flen: cint; from_buf, to_buf: PByte; arsa: PRSA; padding: cint): cint;
procedure RSA_free(arsa: PRSA);
//
// RSA_up_flags
function RSA_flags(arsa: PRSA): integer;
//
procedure RSA_set_default_method(method: PRSA_METHOD);
function RSA_get_default_method: PRSA_METHOD;
function RSA_get_method(arsa: PRSA): PRSA_METHOD;
function RSA_set_method(arsa: PRSA; method: PRSA_METHOD): PRSA_METHOD;
//
// RSA_memory_lock

// X509 Functions

function d2i_RSAPublicKey(arsa: PPRSA; pp: PPByte; len: cint): PRSA;
function i2d_RSAPublicKey(arsa: PRSA; pp: PPByte): cint;
function d2i_RSAPrivateKey(arsa: PPRSA; pp: PPByte; len: cint): PRSA;
function i2d_RSAPrivateKey(arsa: PRSA; pp: PPByte): cint;

// ERR Functions

function Err_Error_String(E: cint; buf: PCharA): PCharA;

// Crypto Functions

function SSLeay_version(t: cint): PCharA;

// EVP Functions - evp.h
function EVP_des_ede3_cbc: PEVP_CIPHER;
Function EVP_enc_null: PEVP_CIPHER;
Function EVP_rc2_cbc: PEVP_CIPHER;
Function EVP_rc2_40_cbc: PEVP_CIPHER;
Function EVP_rc2_64_cbc: PEVP_CIPHER;
Function EVP_rc4: PEVP_CIPHER;
Function EVP_rc4_40: PEVP_CIPHER;
Function EVP_des_cbc: PEVP_CIPHER;
Function EVP_aes_128_cbc: PEVP_CIPHER;
Function EVP_aes_192_cbc: PEVP_CIPHER;
Function EVP_aes_256_cbc: PEVP_CIPHER;
Function EVP_aes_128_cfb8: PEVP_CIPHER;
Function EVP_aes_192_cfb8: PEVP_CIPHER;
Function EVP_aes_256_cfb8: PEVP_CIPHER;
Function EVP_camellia_128_cbc: PEVP_CIPHER;
Function EVP_camellia_192_cbc: PEVP_CIPHER;
Function EVP_camellia_256_cbc: PEVP_CIPHER;

procedure OpenSSL_add_all_algorithms;
procedure OpenSSL_add_all_ciphers;
procedure OpenSSL_add_all_digests;
//
function EVP_DigestInit(ctx: PEVP_MD_CTX; type_: PEVP_MD): cint;
function EVP_DigestUpdate(ctx: PEVP_MD_CTX; const data: Pointer; cnt: csize_t): cint;
function EVP_DigestFinal(ctx: PEVP_MD_CTX; md: PByte; s: pcuint): cint;
function EVP_SignFinal(ctx: PEVP_MD_CTX; sig: Pointer; var s: cardinal; key: PEVP_PKEY): integer;
function EVP_PKEY_size(key: PEVP_PKEY): integer;
procedure EVP_PKEY_free(key: PEVP_PKEY);
function EVP_VerifyFinal(ctx: PEVP_MD_CTX; sigbuf: Pointer; siglen: cardinal; pkey: PEVP_PKEY): integer;
//
function EVP_get_cipherbyname(const name: PCharA): PEVP_CIPHER;
function EVP_get_digestbyname(const name: PCharA): PEVP_MD;
//
procedure EVP_CIPHER_CTX_init(A: PEVP_CIPHER_CTX);
function EVP_CIPHER_CTX_cleanup(A: PEVP_CIPHER_CTX): cint;
function EVP_CIPHER_CTX_set_key_length(x: PEVP_CIPHER_CTX; keylen: cint): cint;
function EVP_CIPHER_CTX_ctrl(ctx: PEVP_CIPHER_CTX; type_, arg: cint; ptr: Pointer): cint;
//
function EVP_EncryptInit(ctx: PEVP_CIPHER_CTX; const chipher_: PEVP_CIPHER; const key, iv: PByte): cint;
function EVP_EncryptUpdate(ctx: PEVP_CIPHER_CTX; out_: pcuchar; outlen: pcint; const in_: pcuchar; inlen: cint): cint;
function EVP_EncryptFinal(ctx: PEVP_CIPHER_CTX; out_data: PByte; outlen: pcint): cint;
//
function EVP_DecryptInit(ctx: PEVP_CIPHER_CTX; chiphir_type: PEVP_CIPHER; const key, iv: PByte): cint;
function EVP_DecryptUpdate(ctx: PEVP_CIPHER_CTX; out_data: PByte; outl: pcint; const in_: PByte; inl: cint): cint;
function EVP_DecryptFinal(ctx: PEVP_CIPHER_CTX; outm: PByte; outlen: pcint): cint;
//
// PEM Functions - pem.h
//
function PEM_read_bio_PrivateKey(bp: PBIO; x: PPEVP_PKEY; cb: Ppem_password_cb; u: Pointer): PEVP_PKEY;
function PEM_read_bio_PUBKEY(bp: PBIO; var x: PEVP_PKEY; cb: Ppem_password_cb; u: Pointer): PEVP_PKEY;
function PEM_write_bio_PrivateKey(bp: PBIO; x: PEVP_PKEY; const enc: PEVP_CIPHER; kstr: PCharA; klen: integer;
  cb: Ppem_password_cb; u: Pointer): integer;
function PEM_write_bio_PUBKEY(bp: PBIO; x: PEVP_PKEY): integer;

// BIO Functions - bio.h
function BioNew(B: PBIO_METHOD): PBIO;
procedure BioFreeAll(B: PBIO);
function BioSMem: PBIO_METHOD;
function BioCtrlPending(B: PBIO): cint;
function BioRead(B: PBIO; var buf: StringA; len: cint): cint;
function BioWrite(B: PBIO; buf: StringA; len: cint): cint;
function BIO_ctrl(bp: PBIO; cmd: cint; larg: clong; parg: Pointer): clong;
function BIO_read_filename(B: PBIO; const name: PCharA): cint;

function BIO_s_file: PBIO_METHOD;
function BIO_new_file(const filename: PCharA; const mode: PCharA): PBIO;
function BIO_new_mem_buf(buf: Pointer; len: integer): PBIO;
procedure CRYPTOcleanupAllExData;
procedure OPENSSLaddallalgorithms;

function IsSSLloaded: Boolean;
function InitSSLInterface: Boolean; overload;
function DestroySSLInterface: Boolean;

// compatibility with old versions.
function Islibealoaded: Boolean; deprecated;
function InitSSLInterface(AVerboseLoading: Boolean): Boolean; overload; deprecated;
function InitSSLEAInterface(AVerboseLoading: Boolean): Boolean; deprecated;
function InitLibeaInterface(AVerboseLoading: Boolean = false): Boolean; deprecated;
function DestroySSLEAInterface: Boolean; deprecated;
function DestroyLibeaInterface: Boolean; deprecated;

var
  OpenSSL_unavailable_functions: string;

implementation

{
  Compatibility functions
}

Var
  SSLloaded: Boolean = false;
  LoadVerbose: Boolean;
  SSLCS: TRTLCriticalSection;
  Locks: Array of TRTLCriticalSection;

function Islibealoaded: Boolean; deprecated;
begin
  Result := IsSSLloaded;
end;

function InitSSLInterface(AVerboseLoading: Boolean): Boolean; deprecated;

Var
  B: Boolean;

begin
  B := LoadVerbose;
  LoadVerbose := AVerboseLoading;
  try
    Result := InitSSLInterface;
  finally
    LoadVerbose := B;
  end;
end;

function InitSSLEAInterface(AVerboseLoading: Boolean): Boolean; deprecated;

Var
  B: Boolean;

begin
  B := LoadVerbose;
  LoadVerbose := AVerboseLoading;
  try
    Result := InitSSLInterface;
  finally
    LoadVerbose := B;
  end;
end;

function InitLibeaInterface(AVerboseLoading: Boolean = false): Boolean; deprecated;

Var
  B: Boolean;

begin
  B := LoadVerbose;
  LoadVerbose := AVerboseLoading;
  try
    Result := InitSSLInterface;
  finally
    LoadVerbose := B;
  end;
end;

function DestroySSLEAInterface: Boolean; deprecated;

begin
  Result := DestroySSLInterface;
end;

function DestroyLibeaInterface: Boolean; deprecated;

begin
  Result := DestroySSLInterface;
end;

type
  // libssl.dll
  TSslGetError = function(s: PSSL; ret_code: cint): cint; cdecl;
  TSslLibraryInit = function: cint; cdecl;
  TSslLoadErrorStrings = procedure; cdecl;
  TSslCtxSetCipherList = function(arg0: PSSL_CTX; str: PCharA): cint; cdecl;
  TSslCtxNew = function(meth: PSSL_METHOD): PSSL_CTX; cdecl;
  TSslCtxFree = procedure(arg0: PSSL_CTX); cdecl;
  TSslSetFd = function(s: PSSL; fd: cint): cint; cdecl;
  TSslCtrl = function(ssl: PSSL; cmd: cint; larg: clong; parg: Pointer): clong; cdecl;
  TSslCTXCtrl = function(ctx: PSSL_CTX; cmd: cint; larg: clong; parg: Pointer): clong; cdecl;
  TSslMethodV2 = function: PSSL_METHOD; cdecl;
  TSslMethodV3 = function: PSSL_METHOD; cdecl;
  TSslMethodTLSV1 = function: PSSL_METHOD; cdecl;
  TSslMethodV23 = function: PSSL_METHOD; cdecl;
  TSslCtxUsePrivateKey = function(ctx: PSSL_CTX; pkey: SslPtr): cint; cdecl;
  TSslCtxUsePrivateKeyASN1 = function(pk: cint; ctx: PSSL_CTX; D: SslPtr; len: cint): cint; cdecl;
  TSslCtxUsePrivateKeyFile = function(ctx: PSSL_CTX; const _file: PCharA; _type: cint): cint; cdecl;
  TSslCtxUseCertificate = function(ctx: PSSL_CTX; x: SslPtr): cint; cdecl;
  TSslCtxUseCertificateASN1 = function(ctx: PSSL_CTX; len: cint; D: SslPtr): cint; cdecl;
  TSslCtxUseCertificateFile = function(ctx: PSSL_CTX; const _file: PCharA; _type: cint): cint; cdecl;
  TSslCtxUseCertificateChainFile = function(ctx: PSSL_CTX; const _file: PCharA): cint; cdecl;
  TSslCtxCheckPrivateKeyFile = function(ctx: PSSL_CTX): cint; cdecl;
  TSslCtxSetDefaultPasswdCb = procedure(ctx: PSSL_CTX; cb: SslPtr); cdecl;
  TSslCtxSetDefaultPasswdCbUserdata = procedure(ctx: PSSL_CTX; u: SslPtr); cdecl;
  TSslCtxLoadVerifyLocations = function(ctx: PSSL_CTX; const CAfile: PCharA; const CApath: PCharA): cint; cdecl;
  TSslNew = function(ctx: PSSL_CTX): PSSL; cdecl;
  TSslFree = procedure(ssl: PSSL); cdecl;
  TSslAccept = function(ssl: PSSL): cint; cdecl;
  TSslConnect = function(ssl: PSSL): cint; cdecl;
  TSslShutdown = function(ssl: PSSL): cint; cdecl;
  TSslRead = function(ssl: PSSL; buf: PCharA; num: cint): cint; cdecl;
  TSslPeek = function(ssl: PSSL; buf: PCharA; num: cint): cint; cdecl;
  TSslWrite = function(ssl: PSSL; const buf: PCharA; num: cint): cint; cdecl;
  TSslPending = function(ssl: PSSL): cint; cdecl;
  TSslGetVersion = function(ssl: PSSL): PCharA; cdecl;
  TSslGetPeerCertificate = function(ssl: PSSL): pX509; cdecl;
  TSslCtxSetVerify = procedure(ctx: PSSL_CTX; mode: cint; arg2: SslPtr); cdecl;
  TSSLGetCurrentCipher = function(s: PSSL): SslPtr; cdecl;
  TSSLCipherGetName = function(C: SslPtr): PCharA; cdecl;
  TSSLCipherGetBits = function(C: SslPtr; alg_bits: pcint): cint; cdecl;
  TSSLGetVerifyResult = function(ssl: PSSL): cint; cdecl;

  // libeay.dll
  TERR_load_crypto_strings = procedure; cdecl;
  TX509New = function: pX509; cdecl;
  TX509Free = procedure(x: pX509); cdecl;
  TX509NameOneline = function(A: PX509_NAME; buf: PCharA; size: cint): PCharA; cdecl;
  TX509GetSubjectName = function(A: pX509): PX509_NAME; cdecl;
  TX509GetIssuerName = function(A: pX509): PX509_NAME; cdecl;
  TX509NameHash = function(x: PX509_NAME): culong; cdecl;
  TX509Digest = function(data: pX509; _type: PEVP_MD; md: PCharA; len: pcint): cint; cdecl;
  TX509print = function(B: PBIO; A: pX509): cint; cdecl;
  TX509SetVersion = function(x: pX509; version: cint): cint; cdecl;
  TX509SetPubkey = function(x: pX509; pkey: PEVP_PKEY): cint; cdecl;
  TX509SetIssuerName = function(x: pX509; name: PX509_NAME): cint; cdecl;
  TX509NameAddEntryByTxt = function(name: PX509_NAME; field: PCharA; _type: cint; bytes: PCharA; len, loc, _set: cint)
    : cint; cdecl;
  TX509Sign = function(x: pX509; pkey: PEVP_PKEY; const md: PEVP_MD): cint; cdecl;
  TX509GmtimeAdj = function(s: PASN1_UTCTIME; adj: cint): PASN1_UTCTIME; cdecl;
  TX509SetNotBefore = function(x: pX509; tm: PASN1_UTCTIME): cint; cdecl;
  TX509SetNotAfter = function(x: pX509; tm: PASN1_UTCTIME): cint; cdecl;
  TX509GetSerialNumber = function(x: pX509): PASN1_cInt; cdecl;
  TEvpPkeyNew = function: PEVP_PKEY; cdecl;
  TEvpPkeyFree = procedure(pk: PEVP_PKEY); cdecl;
  TEvpPkeyAssign = function(pkey: PEVP_PKEY; _type: cint; key: PRSA): cint; cdecl;
  TEvpGetDigestByName = function(name: PCharA): PEVP_MD; cdecl;
  TEVPcleanup = procedure; cdecl;
  TSSLeayversion = function(t: cint): PCharA; cdecl;
  TErrErrorString = procedure(E: cint; buf: PCharA; len: cint); cdecl;
  TErrGetError = function: cint; cdecl;
  TErrClearError = procedure; cdecl;
  TErrFreeStrings = procedure; cdecl;
  TErrRemoveState = procedure(pid: cint); cdecl;
  TRandScreen = procedure; cdecl;
  TBioNew = function(B: PBIO_METHOD): PBIO; cdecl;
  TBioFreeAll = procedure(B: PBIO); cdecl;
  TBioSMem = function: PBIO_METHOD; cdecl;
  TBioCtrlPending = function(B: PBIO): cint; cdecl;
  TBioRead = function(B: PBIO; buf: PCharA; len: cint): cint; cdecl;
  TBioWrite = function(B: PBIO; buf: PCharA; len: cint): cint; cdecl;
  Td2iPKCS12bio = function(B: PBIO; Pkcs12: SslPtr): SslPtr; cdecl;
  TPKCS12parse = function(p12: SslPtr; pass: PCharA; var pkey, cert, ca: SslPtr): cint; cdecl;
  TPKCS12free = procedure(p12: SslPtr); cdecl;
  TAsn1UtctimeNew = function: PASN1_UTCTIME; cdecl;
  TAsn1UtctimeFree = procedure(A: PASN1_UTCTIME); cdecl;
  TAsn1IntegerSet = function(A: PASN1_INTEGER; v: integer): integer; cdecl;
  TAsn1IntegerGet = function(A: PASN1_INTEGER): integer; cdecl;
  Ti2dX509bio = function(B: PBIO; x: pX509): cint; cdecl;
  Ti2dPrivateKeyBio = function(B: PBIO; pkey: PEVP_PKEY): cint; cdecl;

  // 3DES functions
  TDESsetoddparity = procedure(key: DES_cblock); cdecl;
  TDESsetkeychecked = function(key: DES_cblock; schedule: des_key_schedule): cint; cdecl;
  TDESsetkey = TDESsetkeychecked;
  TDESecbencrypt = procedure(Input: DES_cblock; output: DES_cblock; ks: des_key_schedule; enc: cint); cdecl;
  // thread lock functions
  TCRYPTOnumlocks = function: cint; cdecl;
  TCRYPTOSetLockingCallback = procedure(cb: SslPtr); cdecl;

  // RAND functions
  TRAND_set_rand_method = function(const meth: PRAND_METHOD): cint; cdecl;
  TRAND_get_rand_method = function(): PRAND_METHOD; cdecl;
  TRAND_SSLeay = function(): PRAND_METHOD; cdecl;
  TRAND_cleanup = procedure(); cdecl;
  TRAND_bytes = function(buf: PByte; num: cint): cint; cdecl;
  TRAND_pseudo_bytes = function(buf: PByte; num: cint): cint; cdecl;
  TRAND_seed = procedure(const buf: Pointer; num: cint); cdecl;
  TRAND_add = procedure(const buf: Pointer; num: cint; entropy: cdouble); cdecl;
  TRAND_load_file = function(const file_name: PCharA; max_bytes: clong): cint; cdecl;
  TRAND_write_file = function(const file_name: PCharA): cint; cdecl;
  TRAND_file_name = function(file_name: PCharA; num: csize_t): PCharA; cdecl;
  TRAND_status = function(): cint; cdecl;
  TRAND_query_egd_bytes = function(const path: PCharA; buf: PByte; bytes: cint): cint; cdecl;
  TRAND_egd = function(const path: PCharA): cint; cdecl;
  TRAND_egd_bytes = function(const path: PCharA; bytes: cint): cint; cdecl;
  TERR_load_RAND_strings = procedure(); cdecl;
  TRAND_poll = function(): cint; cdecl;

  // RSA Functions
  TRSA_new = function(): PRSA; cdecl;
  TRSA_new_method = function(method: PENGINE): PRSA; cdecl;
  TRSA_size = function(arsa: PRSA): cint; cdecl;
  TRsaGenerateKey = function(bits, E: cint; callback: PFunction; cb_arg: SslPtr): PRSA; cdecl;
  TRSA_generate_key_ex = function(arsa: PRSA; bits: cint; E: PBIGNUM; cb: PBN_GENCB): PRSA; cdecl;
  TRSA_check_key = function(arsa: PRSA): cint; cdecl;
  TRSA_public_encrypt = function(flen: cint; from_buf, to_buf: PByte; arsa: PRSA; padding: cint): cint; cdecl;
  TRSA_private_encrypt = function(flen: cint; from_buf, to_buf: PByte; arsa: PRSA; padding: cint): cint; cdecl;
  TRSA_public_decrypt = function(flen: cint; from_buf, to_buf: PByte; arsa: PRSA; padding: cint): cint; cdecl;
  TRSA_private_decrypt = function(flen: cint; from_buf, to_buf: PByte; arsa: PRSA; padding: cint): cint; cdecl;
  TRSA_free = procedure(arsa: PRSA); cdecl;
  TRSA_flags = function(arsa: PRSA): integer; cdecl;
  TRSA_set_default_method = procedure(method: PRSA_METHOD); cdecl;
  TRSA_get_default_method = function: PRSA_METHOD; cdecl;
  TRSA_get_method = function(PRSA: PRSA): PRSA_METHOD; cdecl;
  TRSA_set_method = function(arsa: PRSA; method: PRSA_METHOD): PRSA_METHOD; cdecl;

  // X509 Functions

  Td2i_RSAPublicKey = function(arsa: PPRSA; pp: PPByte; len: cint): PRSA; cdecl;
  Ti2d_RSAPublicKey = function(arsa: PRSA; pp: PPByte): cint; cdecl;
  Td2i_RSAPrivateKey = function(arsa: PPRSA; pp: PPByte; len: cint): PRSA; cdecl;
  Ti2d_RSAPrivateKey = function(arsa: PRSA; pp: PPByte): cint; cdecl;

  // ERR Functions

  TErr_Error_String = function(E: cint; buf: PCharA): PCharA; cdecl;

  // Crypto Functions

  TSSLeay_version = function(t: cint): PCharA; cdecl;
  TCRYPTOcleanupAllExData = procedure; cdecl;
  TOPENSSLaddallalgorithms = procedure; cdecl;

  // EVP Functions

  TOpenSSL_add_all_algorithms = procedure(); cdecl;
  TOpenSSL_add_all_ciphers = procedure(); cdecl;
  TOpenSSL_add_all_digests = procedure(); cdecl;
  //
  TEVP_DigestInit = function(ctx: PEVP_MD_CTX; type_: PEVP_MD): cint; cdecl;
  TEVP_DigestUpdate = function(ctx: PEVP_MD_CTX; const data: Pointer; cnt: csize_t): cint; cdecl;
  TEVP_DigestFinal = function(ctx: PEVP_MD_CTX; md: PByte; s: pcuint): cint; cdecl;

  TEVP_SignFinal = function(ctx: PEVP_MD_CTX; sig: Pointer; var s: cardinal; key: PEVP_PKEY): integer; cdecl;
  TEVP_PKEY_size = function(key: PEVP_PKEY): integer; cdecl;
  TEVP_PKEY_free = Procedure(key: PEVP_PKEY); cdecl;
  TEVP_VerifyFinal = function(ctx: PEVP_MD_CTX; sigbuf: Pointer; siglen: cardinal; pkey: PEVP_PKEY): integer; cdecl;
  //
  TEVP_CIPHERFunction = function(): PEVP_CIPHER; cdecl;
  TEVP_get_cipherbyname = function(const name: PCharA): PEVP_CIPHER; cdecl;
  TEVP_get_digestbyname = function(const name: PCharA): PEVP_MD; cdecl;
  //
  TEVP_CIPHER_CTX_init = procedure(A: PEVP_CIPHER_CTX); cdecl;
  TEVP_CIPHER_CTX_cleanup = function(A: PEVP_CIPHER_CTX): cint; cdecl;
  TEVP_CIPHER_CTX_set_key_length = function(x: PEVP_CIPHER_CTX; keylen: cint): cint; cdecl;
  TEVP_CIPHER_CTX_ctrl = function(ctx: PEVP_CIPHER_CTX; type_, arg: cint; ptr: Pointer): cint; cdecl;
  //
  TEVP_EncryptInit = function(ctx: PEVP_CIPHER_CTX; const chipher_: PEVP_CIPHER; const key, iv: PByte): cint; cdecl;
  TEVP_EncryptUpdate = function(ctx: PEVP_CIPHER_CTX; out_: pcuchar; outlen: pcint; const in_: pcuchar; inlen: cint)
    : cint; cdecl;
  TEVP_EncryptFinal = function(ctx: PEVP_CIPHER_CTX; out_data: PByte; outlen: pcint): cint; cdecl;
  //
  TEVP_DecryptInit = function(ctx: PEVP_CIPHER_CTX; chiphir_type: PEVP_CIPHER; const key, iv: PByte): cint; cdecl;
  TEVP_DecryptUpdate = function(ctx: PEVP_CIPHER_CTX; out_data: PByte; outl: pcint; const in_: PByte; inl: cint): cint; cdecl;
  TEVP_DecryptFinal = function(ctx: PEVP_CIPHER_CTX; outm: PByte; outlen: pcint): cint; cdecl;

  // PEM functions

  TPEM_read_bio_PrivateKey = function(bp: PBIO; x: PPEVP_PKEY; cb: Ppem_password_cb; u: Pointer): PEVP_PKEY; cdecl;

  TPEM_read_bio_PUBKEY = function(bp: PBIO; var x: PEVP_PKEY; cb: Ppem_password_cb; u: Pointer): PEVP_PKEY; cdecl;
  TPEM_write_bio_PrivateKey = function(bp: PBIO; x: PEVP_PKEY; const enc: PEVP_CIPHER; kstr: PCharA; klen: integer;
    cb: Ppem_password_cb; u: Pointer): integer; cdecl;
  TPEM_write_bio_PUBKEY = function(bp: PBIO; x: PEVP_PKEY): integer; cdecl;

  // BIO Functions

  TBIO_ctrl = function(bp: PBIO; cmd: cint; larg: clong; parg: Pointer): clong; cdecl;

  TBIO_s_file = function: PBIO_METHOD; cdecl;
  TBIO_new_file = function(const filename: PCharA; const mode: PCharA): PBIO; cdecl;
  TBIO_new_mem_buf = function(buf: Pointer; len: integer): PBIO; cdecl;

var
  // libssl.dll
  _SslGetError: TSslGetError = nil;
  _SslLibraryInit: TSslLibraryInit = nil;
  _SslLoadErrorStrings: TSslLoadErrorStrings = nil;
  _SslCtxSetCipherList: TSslCtxSetCipherList = nil;
  _SslCtxNew: TSslCtxNew = nil;
  _SslCtxFree: TSslCtxFree = nil;
  _SslSetFd: TSslSetFd = nil;
  _SslCtrl: TSslCtrl = nil;
  _SslCTXCtrl: TSslCTXCtrl = nil;
  _SslMethodV2: TSslMethodV2 = nil;
  _SslMethodV3: TSslMethodV3 = nil;
  _SslMethodTLSV1: TSslMethodTLSV1 = nil;
  _SslMethodV23: TSslMethodV23 = nil;
  _SslCtxUsePrivateKey: TSslCtxUsePrivateKey = nil;
  _SslCtxUsePrivateKeyASN1: TSslCtxUsePrivateKeyASN1 = nil;
  _SslCtxUsePrivateKeyFile: TSslCtxUsePrivateKeyFile = nil;
  _SslCtxUseCertificate: TSslCtxUseCertificate = nil;
  _SslCtxUseCertificateASN1: TSslCtxUseCertificateASN1 = nil;
  _SslCtxUseCertificateFile: TSslCtxUseCertificateFile = nil;
  _SslCtxUseCertificateChainFile: TSslCtxUseCertificateChainFile = nil;
  _SslCtxCheckPrivateKeyFile: TSslCtxCheckPrivateKeyFile = nil;
  _SslCtxSetDefaultPasswdCb: TSslCtxSetDefaultPasswdCb = nil;
  _SslCtxSetDefaultPasswdCbUserdata: TSslCtxSetDefaultPasswdCbUserdata = nil;
  _SslCtxLoadVerifyLocations: TSslCtxLoadVerifyLocations = nil;
  _SslNew: TSslNew = nil;
  _SslFree: TSslFree = nil;
  _SslAccept: TSslAccept = nil;
  _SslConnect: TSslConnect = nil;
  _SslShutdown: TSslShutdown = nil;
  _SslRead: TSslRead = nil;
  _SslPeek: TSslPeek = nil;
  _SslWrite: TSslWrite = nil;
  _SslPending: TSslPending = nil;
  _SslGetVersion: TSslGetVersion = nil;
  _SslGetPeerCertificate: TSslGetPeerCertificate = nil;
  _SslCtxSetVerify: TSslCtxSetVerify = nil;
  _SSLGetCurrentCipher: TSSLGetCurrentCipher = nil;
  _SSLCipherGetName: TSSLCipherGetName = nil;
  _SSLCipherGetBits: TSSLCipherGetBits = nil;
  _SSLGetVerifyResult: TSSLGetVerifyResult = nil;

  // libeay.dll
  _ERR_load_crypto_strings: TERR_load_crypto_strings = nil;
  _X509New: TX509New = nil;
  _X509Free: TX509Free = nil;
  _X509NameOneline: TX509NameOneline = nil;
  _X509GetSubjectName: TX509GetSubjectName = nil;
  _X509GetIssuerName: TX509GetIssuerName = nil;
  _X509NameHash: TX509NameHash = nil;
  _X509Digest: TX509Digest = nil;
  _X509print: TX509print = nil;
  _X509SetVersion: TX509SetVersion = nil;
  _X509SetPubkey: TX509SetPubkey = nil;
  _X509SetIssuerName: TX509SetIssuerName = nil;
  _X509NameAddEntryByTxt: TX509NameAddEntryByTxt = nil;
  _X509Sign: TX509Sign = nil;
  _X509GmtimeAdj: TX509GmtimeAdj = nil;
  _X509SetNotBefore: TX509SetNotBefore = nil;
  _X509SetNotAfter: TX509SetNotAfter = nil;
  _X509GetSerialNumber: TX509GetSerialNumber = nil;
  _EvpPkeyNew: TEvpPkeyNew = nil;
  _EvpPkeyFree: TEvpPkeyFree = nil;
  _EvpPkeyAssign: TEvpPkeyAssign = nil;
  _EvpGetDigestByName: TEvpGetDigestByName = nil;
  _EVPcleanup: TEVPcleanup = nil;
  _SSLeayversion: TSSLeayversion = nil;
  _ErrErrorString: TErrErrorString = nil;
  _ErrGetError: TErrGetError = nil;
  _ErrClearError: TErrClearError = nil;
  _ErrFreeStrings: TErrFreeStrings = nil;
  _ErrRemoveState: TErrRemoveState = nil;
  _RandScreen: TRandScreen = nil;
  _BioNew: TBioNew = nil;
  _BioFreeAll: TBioFreeAll = nil;
  _BioSMem: TBioSMem = nil;
  _BioCtrlPending: TBioCtrlPending = nil;
  _BioRead: TBioRead = nil;
  _BioWrite: TBioWrite = nil;
  _d2iPKCS12bio: Td2iPKCS12bio = nil;
  _PKCS12parse: TPKCS12parse = nil;
  _PKCS12free: TPKCS12free = nil;
  _Asn1UtctimeNew: TAsn1UtctimeNew = nil;
  _Asn1UtctimeFree: TAsn1UtctimeFree = nil;
  _Asn1IntegerSet: TAsn1IntegerSet = nil;
  _Asn1IntegerGet: TAsn1IntegerGet = nil;
  _i2dX509bio: Ti2dX509bio = nil;
  _i2dPrivateKeyBio: Ti2dPrivateKeyBio = nil;
  _EVP_enc_null: TEVP_CIPHERFunction = nil;
  _EVP_rc2_cbc: TEVP_CIPHERFunction = nil;
  _EVP_rc2_40_cbc: TEVP_CIPHERFunction = nil;
  _EVP_rc2_64_cbc: TEVP_CIPHERFunction = nil;
  _EVP_rc4: TEVP_CIPHERFunction = nil;
  _EVP_rc4_40: TEVP_CIPHERFunction = nil;
  _EVP_des_cbc: TEVP_CIPHERFunction = nil;
  _EVP_des_ede3_cbc: TEVP_CIPHERFunction = nil;
  _EVP_aes_128_cbc: TEVP_CIPHERFunction = nil;
  _EVP_aes_192_cbc: TEVP_CIPHERFunction = nil;
  _EVP_aes_256_cbc: TEVP_CIPHERFunction = nil;
  _EVP_aes_128_cfb8: TEVP_CIPHERFunction = nil;
  _EVP_aes_192_cfb8: TEVP_CIPHERFunction = nil;
  _EVP_aes_256_cfb8: TEVP_CIPHERFunction = nil;
  _EVP_camellia_128_cbc: TEVP_CIPHERFunction = nil;
  _EVP_camellia_192_cbc: TEVP_CIPHERFunction = nil;
  _EVP_camellia_256_cbc: TEVP_CIPHERFunction = nil;

  // 3DES functions
  _DESsetoddparity: TDESsetoddparity = nil;
  _DESsetkey: TDESsetkey = nil;
  _DESsetkeychecked: TDESsetkeychecked = nil;
  _DESecbencrypt: TDESecbencrypt = nil;
  // thread lock functions
  _CRYPTOnumlocks: TCRYPTOnumlocks = nil;
  _CRYPTOSetLockingCallback: TCRYPTOSetLockingCallback = nil;

  // RAND functions
  _RAND_set_rand_method: TRAND_set_rand_method = nil;
  _RAND_get_rand_method: TRAND_get_rand_method = nil;
  _RAND_SSLeay: TRAND_SSLeay = nil;
  _RAND_cleanup: TRAND_cleanup = nil;
  _RAND_bytes: TRAND_bytes = nil;
  _RAND_pseudo_bytes: TRAND_pseudo_bytes = nil;
  _RAND_seed: TRAND_seed = nil;
  _RAND_add: TRAND_add = nil;
  _RAND_load_file: TRAND_load_file = nil;
  _RAND_write_file: TRAND_write_file = nil;
  _RAND_file_name: TRAND_file_name = nil;
  _RAND_status: TRAND_status = nil;
  _RAND_query_egd_bytes: TRAND_query_egd_bytes = nil;
  _RAND_egd: TRAND_egd = nil;
  _RAND_egd_bytes: TRAND_egd_bytes = nil;
  _ERR_load_RAND_strings: TERR_load_RAND_strings = nil;
  _RAND_poll: TRAND_poll = nil;

  // RSA Functions
  _RSA_new: TRSA_new = nil;
  _RSA_new_method: TRSA_new_method = nil;
  _RSA_size: TRSA_size = nil;
  _RsaGenerateKey: TRsaGenerateKey = nil;
  _RSA_generate_key_ex: TRSA_generate_key_ex = nil;
  _RSA_check_key: TRSA_check_key = nil;
  _RSA_public_encrypt: TRSA_public_encrypt = nil;
  _RSA_private_encrypt: TRSA_private_encrypt = nil;
  _RSA_public_decrypt: TRSA_public_decrypt = nil;
  _RSA_private_decrypt: TRSA_private_decrypt = nil;
  _RSA_free: TRSA_free = nil;
  _RSA_flags: TRSA_flags = nil;
  _RSA_set_default_method: TRSA_set_default_method = nil;
  _RSA_get_default_method: TRSA_get_default_method = nil;
  _RSA_get_method: TRSA_get_method = nil;
  _RSA_set_method: TRSA_set_method = nil;

  // X509 Functions

  _d2i_RSAPublicKey: Td2i_RSAPublicKey = nil;
  _i2d_RSAPublicKey: Ti2d_RSAPublicKey = nil;
  _d2i_RSAPrivateKey: Td2i_RSAPrivateKey = nil;
  _i2d_RSAPrivateKey: Ti2d_RSAPrivateKey = nil;

  // ERR Functions

  _Err_Error_String: TErr_Error_String = nil;

  // Crypto Functions

  _SSLeay_version: TSSLeay_version = nil;
  _CRYPTOcleanupAllExData: TCRYPTOcleanupAllExData = nil;
  _OPENSSLaddallalgorithms: TOPENSSLaddallalgorithms = nil;

  // EVP Functions

  _OpenSSL_add_all_algorithms: TOpenSSL_add_all_algorithms = nil;
  _OpenSSL_add_all_ciphers: TOpenSSL_add_all_ciphers = nil;
  _OpenSSL_add_all_digests: TOpenSSL_add_all_digests = nil;
  //
  _EVP_DigestInit: TEVP_DigestInit = nil;
  _EVP_DigestUpdate: TEVP_DigestUpdate = nil;
  _EVP_DigestFinal: TEVP_DigestFinal = nil;

  _EVP_SignFinal: TEVP_SignFinal = nil;
  _EVP_PKEY_size: TEVP_PKEY_size = nil;
  _EVP_PKEY_free: TEVP_PKEY_free = nil;
  _EVP_VerifyFinal: TEVP_VerifyFinal = nil;
  //
  _EVP_get_cipherbyname: TEVP_get_cipherbyname = nil;
  _EVP_get_digestbyname: TEVP_get_digestbyname = nil;
  //
  _EVP_CIPHER_CTX_init: TEVP_CIPHER_CTX_init = nil;
  _EVP_CIPHER_CTX_cleanup: TEVP_CIPHER_CTX_cleanup = nil;
  _EVP_CIPHER_CTX_set_key_length: TEVP_CIPHER_CTX_set_key_length = nil;
  _EVP_CIPHER_CTX_ctrl: TEVP_CIPHER_CTX_ctrl = nil;
  //
  _EVP_EncryptInit: TEVP_EncryptInit = nil;
  _EVP_EncryptUpdate: TEVP_EncryptUpdate = nil;
  _EVP_EncryptFinal: TEVP_EncryptFinal = nil;
  //
  _EVP_DecryptInit: TEVP_DecryptInit = nil;
  _EVP_DecryptUpdate: TEVP_DecryptUpdate = nil;
  _EVP_DecryptFinal: TEVP_DecryptFinal = nil;

  // PEM
  _PEM_read_bio_PrivateKey: TPEM_read_bio_PrivateKey = nil;

  _PEM_read_bio_PUBKEY: TPEM_read_bio_PUBKEY = nil;
  _PEM_write_bio_PrivateKey: TPEM_write_bio_PrivateKey = nil;
  _PEM_write_bio_PUBKEY: TPEM_write_bio_PUBKEY = nil;

  // BIO Functions

  _BIO_ctrl: TBIO_ctrl = nil;

  _BIO_s_file: TBIO_s_file = nil;
  _BIO_new_file: TBIO_new_file = nil;
  _BIO_new_mem_buf: TBIO_new_mem_buf = nil;


  // libssl.dll

function SslGetError(s: PSSL; ret_code: cint): cint;
begin
  if InitSSLInterface and Assigned(_SslGetError) then
    Result := _SslGetError(s, ret_code)
  else
    Result := SSL_ERROR_SSL;
end;

function SslLibraryInit: cint;
begin
  if InitSSLInterface and Assigned(_SslLibraryInit) then
    Result := _SslLibraryInit
  else
    Result := 1;
end;

procedure SslLoadErrorStrings;
begin
  if InitSSLInterface and Assigned(_SslLoadErrorStrings) then
    _SslLoadErrorStrings;
end;

function SslCtxSetCipherList(arg0: PSSL_CTX; var str: StringA): cint;
begin
  if InitSSLInterface and Assigned(_SslCtxSetCipherList) then
    Result := _SslCtxSetCipherList(arg0, PCharA(str))
  else
    Result := 0;
end;

function SslCtxNew(meth: PSSL_METHOD): PSSL_CTX;
begin
  if InitSSLInterface and Assigned(_SslCtxNew) then
    Result := _SslCtxNew(meth)
  else
    Result := nil;
end;

procedure SslCtxFree(arg0: PSSL_CTX);
begin
  if InitSSLInterface and Assigned(_SslCtxFree) then
    _SslCtxFree(arg0);
end;

function SslSetFd(s: PSSL; fd: cint): cint;
begin
  if InitSSLInterface and Assigned(_SslSetFd) then
    Result := _SslSetFd(s, fd)
  else
    Result := 0;
end;

function SslCtrl(ssl: PSSL; cmd: cint; larg: clong; parg: Pointer): clong;
begin
  if InitSSLInterface and Assigned(_SslCtrl) then
    Result := _SslCtrl(ssl, cmd, larg, parg)
  else
    Result := 0;
end;

function SslCTXCtrl(ctx: PSSL_CTX; cmd: cint; larg: clong; parg: Pointer): clong;
begin
  if InitSSLInterface and Assigned(_SslCTXCtrl) then
    Result := _SslCTXCtrl(ctx, cmd, larg, parg)
  else
    Result := 0;
end;

function SSLCTXSetMode(ctx: PSSL_CTX; mode: clong): clong;
begin
  Result := SslCTXCtrl(ctx, SSL_CTRL_MODE, mode, nil);
end;

function SSLSetMode(s: PSSL; mode: clong): clong;
begin
  Result := SslCtrl(s, SSL_CTRL_MODE, mode, nil);
end;

function SSLCTXGetMode(ctx: PSSL_CTX): clong;
begin
  Result := SslCTXCtrl(ctx, SSL_CTRL_MODE, 0, nil);
end;

function SSLGetMode(s: PSSL): clong;
begin
  Result := SslCtrl(s, SSL_CTRL_MODE, 0, nil);
end;

function SslMethodV2: PSSL_METHOD;
begin
  if InitSSLInterface and Assigned(_SslMethodV2) then
    Result := _SslMethodV2
  else
    Result := nil;
end;

function SslMethodV3: PSSL_METHOD;
begin
  if InitSSLInterface and Assigned(_SslMethodV3) then
    Result := _SslMethodV3
  else
    Result := nil;
end;

function SslMethodTLSV1: PSSL_METHOD;
begin
  if InitSSLInterface and Assigned(_SslMethodTLSV1) then
    Result := _SslMethodTLSV1
  else
    Result := nil;
end;

function SslMethodV23: PSSL_METHOD;
begin
  if InitSSLInterface and Assigned(_SslMethodV23) then
    Result := _SslMethodV23
  else
    Result := nil;
end;

function SslCtxUsePrivateKey(ctx: PSSL_CTX; pkey: SslPtr): cint;
begin
  if InitSSLInterface and Assigned(_SslCtxUsePrivateKey) then
    Result := _SslCtxUsePrivateKey(ctx, pkey)
  else
    Result := 0;
end;

function SslCtxUsePrivateKeyASN1(pk: cint; ctx: PSSL_CTX; D: StringA; len: clong): cint;
begin
  if InitSSLInterface and Assigned(_SslCtxUsePrivateKeyASN1) then
    Result := _SslCtxUsePrivateKeyASN1(pk, ctx, SslPtr(D), len)
  else
    Result := 0;
end;

function SslCtxUsePrivateKeyFile(ctx: PSSL_CTX; const _file: StringA; _type: cint): cint;
begin
  if InitSSLInterface and Assigned(_SslCtxUsePrivateKeyFile) then
    Result := _SslCtxUsePrivateKeyFile(ctx, PAnsiChar(StringA(_file)), _type)
  else
    Result := 0;
end;

function SslCtxUseCertificate(ctx: PSSL_CTX; x: SslPtr): cint;
begin
  if InitSSLInterface and Assigned(_SslCtxUseCertificate) then
    Result := _SslCtxUseCertificate(ctx, x)
  else
    Result := 0;
end;

function SslCtxUseCertificateASN1(ctx: PSSL_CTX; len: clong; D: StringA): cint;
begin
  if InitSSLInterface and Assigned(_SslCtxUseCertificateASN1) then
    Result := _SslCtxUseCertificateASN1(ctx, len, SslPtr(D))
  else
    Result := 0;
end;

function SslCtxUseCertificateFile(ctx: PSSL_CTX; const _file: StringA; _type: cint): cint;
begin
  if InitSSLInterface and Assigned(_SslCtxUseCertificateFile) then
    Result := _SslCtxUseCertificateFile(ctx, PCharA(StringA(_file)), _type)
  else
    Result := 0;
end;

function SslCtxUseCertificateChainFile(ctx: PSSL_CTX; const _file: StringA): cint;
begin
  if InitSSLInterface and Assigned(_SslCtxUseCertificateChainFile) then
    Result := _SslCtxUseCertificateChainFile(ctx, PCharA(StringA(_file)))
  else
    Result := 0;
end;

function SslCtxCheckPrivateKeyFile(ctx: PSSL_CTX): cint;
begin
  if InitSSLInterface and Assigned(_SslCtxCheckPrivateKeyFile) then
    Result := _SslCtxCheckPrivateKeyFile(ctx)
  else
    Result := 0;
end;

procedure SslCtxSetDefaultPasswdCb(ctx: PSSL_CTX; cb: PPasswdCb);
begin
  if InitSSLInterface and Assigned(_SslCtxSetDefaultPasswdCb) then
    _SslCtxSetDefaultPasswdCb(ctx, cb);
end;

procedure SslCtxSetDefaultPasswdCbUserdata(ctx: PSSL_CTX; u: SslPtr);
begin
  if InitSSLInterface and Assigned(_SslCtxSetDefaultPasswdCbUserdata) then
    _SslCtxSetDefaultPasswdCbUserdata(ctx, u);
end;

function SslCtxLoadVerifyLocations(ctx: PSSL_CTX; const CAfile: StringA; const CApath: StringA): cint;
begin
  if InitSSLInterface and Assigned(_SslCtxLoadVerifyLocations) then
    Result := _SslCtxLoadVerifyLocations(ctx, SslPtr((CAfile)), SslPtr((CApath)))
  else
    Result := 0;
end;

function SslNew(ctx: PSSL_CTX): PSSL;
begin
  if InitSSLInterface and Assigned(_SslNew) then
    Result := _SslNew(ctx)
  else
    Result := nil;
end;

procedure SslFree(ssl: PSSL);
begin
  if InitSSLInterface and Assigned(_SslFree) then
    _SslFree(ssl);
end;

function SslAccept(ssl: PSSL): cint;
begin
  if InitSSLInterface and Assigned(_SslAccept) then
    Result := _SslAccept(ssl)
  else
    Result := -1;
end;

function SslConnect(ssl: PSSL): cint;
begin
  if InitSSLInterface and Assigned(_SslConnect) then
    Result := _SslConnect(ssl)
  else
    Result := -1;
end;

function SslShutdown(ssl: PSSL): cint;
begin
  if InitSSLInterface and Assigned(_SslShutdown) then
    Result := _SslShutdown(ssl)
  else
    Result := -1;
end;

function SslRead(ssl: PSSL; buf: SslPtr; num: cint): cint;
begin
  if InitSSLInterface and Assigned(_SslRead) then
    Result := _SslRead(ssl, PCharA(buf), num)
  else
    Result := -1;
end;

function SslPeek(ssl: PSSL; buf: SslPtr; num: cint): cint;
begin
  if InitSSLInterface and Assigned(_SslPeek) then
    Result := _SslPeek(ssl, PCharA(buf), num)
  else
    Result := -1;
end;

function SslWrite(ssl: PSSL; buf: SslPtr; num: cint): cint;
begin
  if InitSSLInterface and Assigned(_SslWrite) then
    Result := _SslWrite(ssl, PCharA(buf), num)
  else
    Result := -1;
end;

function SslPending(ssl: PSSL): cint;
begin
  if InitSSLInterface and Assigned(_SslPending) then
    Result := _SslPending(ssl)
  else
    Result := 0;
end;

// function SslGetVersion(ssl: PSSL):PCharA;
function SslGetVersion(ssl: PSSL): StringA;
begin
  if InitSSLInterface and Assigned(_SslGetVersion) then
    Result := _SslGetVersion(ssl)
  else
    Result := '';
end;

function SslGetPeerCertificate(ssl: PSSL): pX509;
begin
  if InitSSLInterface and Assigned(_SslGetPeerCertificate) then
    Result := _SslGetPeerCertificate(ssl)
  else
    Result := nil;
end;

procedure SslCtxSetVerify(ctx: PSSL_CTX; mode: cint; arg2: PFunction);
begin
  if InitSSLInterface and Assigned(_SslCtxSetVerify) then
    _SslCtxSetVerify(ctx, mode, @arg2);
end;

function SSLGetCurrentCipher(s: PSSL): SslPtr;
begin
  if InitSSLInterface and Assigned(_SSLGetCurrentCipher) then
{$IFDEF CIL}
{$ELSE}
    Result := _SSLGetCurrentCipher(s)
{$ENDIF}
  else
    Result := nil;
end;

function SSLCipherGetName(C: SslPtr): StringA;
begin
  if InitSSLInterface and Assigned(_SSLCipherGetName) then
    Result := _SSLCipherGetName(C)
  else
    Result := '';
end;

function SSLCipherGetBits(C: SslPtr; var alg_bits: cint): cint;
begin
  if InitSSLInterface and Assigned(_SSLCipherGetBits) then
    Result := _SSLCipherGetBits(C, @alg_bits)
  else
    Result := 0;
end;

function SSLGetVerifyResult(ssl: PSSL): clong;
begin
  if InitSSLInterface and Assigned(_SSLGetVerifyResult) then
    Result := _SSLGetVerifyResult(ssl)
  else
    Result := X509_V_ERR_APPLICATION_VERIFICATION;
end;

// libeay.dll
function SSLeayversion(t: cint): StringA;
begin
  if InitSSLInterface and Assigned(_SSLeayversion) then
    Result := PCharA(_SSLeayversion(t))
  else
    Result := '';
end;

procedure ERR_load_crypto_strings;
Begin
  if InitSSLInterface and Assigned(_ERR_load_crypto_strings) then
    _ERR_load_crypto_strings;
end;

function X509New: pX509;
begin
  if InitSSLInterface and Assigned(_X509New) then
    Result := _X509New
  else
    Result := nil;
end;

procedure X509Free(x: pX509);
begin
  if InitSSLInterface and Assigned(_X509Free) then
    _X509Free(x);
end;

function X509NameOneline(A: PX509_NAME; var buf: StringA; size: cint): StringA;
begin
  if InitSSLInterface and Assigned(_X509NameOneline) then
    Result := _X509NameOneline(A, PCharA(buf), size)
  else
    Result := '';
end;

function X509GetSubjectName(A: pX509): PX509_NAME;
begin
  if InitSSLInterface and Assigned(_X509GetSubjectName) then
    Result := _X509GetSubjectName(A)
  else
    Result := nil;
end;

function X509GetIssuerName(A: pX509): PX509_NAME;
begin
  if InitSSLInterface and Assigned(_X509GetIssuerName) then
    Result := _X509GetIssuerName(A)
  else
    Result := nil;
end;

function X509NameHash(x: PX509_NAME): culong;
begin
  if InitSSLInterface and Assigned(_X509NameHash) then
    Result := _X509NameHash(x)
  else
    Result := 0;
end;

function X509Digest(data: pX509; _type: PEVP_MD; md: StringA; var len: cint): cint;
begin
  if InitSSLInterface and Assigned(_X509Digest) then
    Result := _X509Digest(data, _type, PCharA(md), @len)
  else
    Result := 0;
end;

function EvpPkeyNew: PEVP_PKEY;
begin
  if InitSSLInterface and Assigned(_EvpPkeyNew) then
    Result := _EvpPkeyNew
  else
    Result := nil;
end;

procedure EvpPkeyFree(pk: PEVP_PKEY);
begin
  if InitSSLInterface and Assigned(_EvpPkeyFree) then
    _EvpPkeyFree(pk);
end;

procedure ErrErrorString(E: cint; var buf: StringA; len: cint);
begin
  if InitSSLInterface and Assigned(_ErrErrorString) then
    _ErrErrorString(E, Pointer(buf), len);
  buf := PCharA(buf);
end;

function ErrGetError: cint;
begin
  if InitSSLInterface and Assigned(_ErrGetError) then
    Result := _ErrGetError
  else
    Result := SSL_ERROR_SSL;
end;

procedure ErrClearError;
begin
  if InitSSLInterface and Assigned(_ErrClearError) then
    _ErrClearError;
end;

procedure ErrFreeStrings;
begin
  if InitSSLInterface and Assigned(_ErrFreeStrings) then
    _ErrFreeStrings;
end;

procedure ErrRemoveState(pid: cint);
begin
  if InitSSLInterface and Assigned(_ErrRemoveState) then
    _ErrRemoveState(pid);
end;

procedure EVPcleanup;
begin
  if InitSSLInterface and Assigned(_EVPcleanup) then
    _EVPcleanup;
end;

procedure RandScreen;
begin
  if InitSSLInterface and Assigned(_RandScreen) then
    _RandScreen;
end;

function BioNew(B: PBIO_METHOD): PBIO;
begin
  if InitSSLInterface and Assigned(_BioNew) then
    Result := _BioNew(B)
  else
    Result := nil;
end;

procedure BioFreeAll(B: PBIO);
begin
  if InitSSLInterface and Assigned(_BioFreeAll) then
    _BioFreeAll(B);
end;

function BioSMem: PBIO_METHOD;
begin
  if InitSSLInterface and Assigned(_BioSMem) then
    Result := _BioSMem
  else
    Result := nil;
end;

function BioCtrlPending(B: PBIO): cint;
begin
  if InitSSLInterface and Assigned(_BioCtrlPending) then
    Result := _BioCtrlPending(B)
  else
    Result := 0;
end;

function BioRead(B: PBIO; var buf: StringA; len: cint): cint;
begin
  if InitSSLInterface and Assigned(_BioRead) then
    Result := _BioRead(B, PCharA(buf), len)
  else
    Result := -2;
end;

// function BioWrite(b: PBIO; Buf: PCharA; Len: cInt): cInt;
function BioWrite(B: PBIO; buf: StringA; len: cint): cint;
begin
  if InitSSLInterface and Assigned(_BioWrite) then
    Result := _BioWrite(B, PCharA(buf), len)
  else
    Result := -2;
end;

function X509print(B: PBIO; A: pX509): cint;
begin
  if InitSSLInterface and Assigned(_X509print) then
    Result := _X509print(B, A)
  else
    Result := 0;
end;

function d2iPKCS12bio(B: PBIO; Pkcs12: SslPtr): SslPtr;
begin
  if InitSSLInterface and Assigned(_d2iPKCS12bio) then
    Result := _d2iPKCS12bio(B, Pkcs12)
  else
    Result := nil;
end;

function PKCS12parse(p12: SslPtr; pass: StringA; var pkey, cert, ca: SslPtr): cint;
begin
  if InitSSLInterface and Assigned(_PKCS12parse) then
    Result := _PKCS12parse(p12, SslPtr(pass), pkey, cert, ca)
  else
    Result := 0;
end;

procedure PKCS12free(p12: SslPtr);
begin
  if InitSSLInterface and Assigned(_PKCS12free) then
    _PKCS12free(p12);
end;

function EvpPkeyAssign(pkey: PEVP_PKEY; _type: cint; key: PRSA): cint;
begin
  if InitSSLInterface and Assigned(_EvpPkeyAssign) then
    Result := _EvpPkeyAssign(pkey, _type, key)
  else
    Result := 0;
end;

function X509SetVersion(x: pX509; version: cint): cint;
begin
  if InitSSLInterface and Assigned(_X509SetVersion) then
    Result := _X509SetVersion(x, version)
  else
    Result := 0;
end;

function X509SetPubkey(x: pX509; pkey: PEVP_PKEY): cint;
begin
  if InitSSLInterface and Assigned(_X509SetPubkey) then
    Result := _X509SetPubkey(x, pkey)
  else
    Result := 0;
end;

function X509SetIssuerName(x: pX509; name: PX509_NAME): cint;
begin
  if InitSSLInterface and Assigned(_X509SetIssuerName) then
    Result := _X509SetIssuerName(x, name)
  else
    Result := 0;
end;

function X509NameAddEntryByTxt(name: PX509_NAME; field: StringA; _type: cint; bytes: StringA; len, loc, _set: cint): cint;
begin
  if InitSSLInterface and Assigned(_X509NameAddEntryByTxt) then
    Result := _X509NameAddEntryByTxt(name, PCharA(field), _type, PCharA(bytes), len, loc, _set)
  else
    Result := 0;
end;

function X509Sign(x: pX509; pkey: PEVP_PKEY; const md: PEVP_MD): cint;
begin
  if InitSSLInterface and Assigned(_X509Sign) then
    Result := _X509Sign(x, pkey, md)
  else
    Result := 0;
end;

function Asn1UtctimeNew: PASN1_UTCTIME;
begin
  if InitSSLInterface and Assigned(_Asn1UtctimeNew) then
    Result := _Asn1UtctimeNew
  else
    Result := nil;
end;

procedure Asn1UtctimeFree(A: PASN1_UTCTIME);
begin
  if InitSSLInterface and Assigned(_Asn1UtctimeFree) then
    _Asn1UtctimeFree(A);
end;

function Asn1IntegerSet(A: PASN1_INTEGER; v: integer): integer;
begin
  if InitSSLInterface and Assigned(_Asn1IntegerSet) then
    Result := _Asn1IntegerSet(A, v)
  else
    Result := 0;
end;

function Asn1IntegerGet(A: PASN1_INTEGER): integer;
begin
  if InitSSLInterface and Assigned(_Asn1IntegerGet) then
    Result := _Asn1IntegerGet(A)
  else
    Result := 0;
end;

function X509GmtimeAdj(s: PASN1_UTCTIME; adj: cint): PASN1_UTCTIME;
begin
  if InitSSLInterface and Assigned(_X509GmtimeAdj) then
    Result := _X509GmtimeAdj(s, adj)
  else
    Result := nil;
end;

function X509SetNotBefore(x: pX509; tm: PASN1_UTCTIME): cint;
begin
  if InitSSLInterface and Assigned(_X509SetNotBefore) then
    Result := _X509SetNotBefore(x, tm)
  else
    Result := 0;
end;

function X509SetNotAfter(x: pX509; tm: PASN1_UTCTIME): cint;
begin
  if InitSSLInterface and Assigned(_X509SetNotAfter) then
    Result := _X509SetNotAfter(x, tm)
  else
    Result := 0;
end;

function i2dX509bio(B: PBIO; x: pX509): cint;
begin
  if InitSSLInterface and Assigned(_i2dX509bio) then
    Result := _i2dX509bio(B, x)
  else
    Result := 0;
end;

function i2dPrivateKeyBio(B: PBIO; pkey: PEVP_PKEY): cint;
begin
  if InitSSLInterface and Assigned(_i2dPrivateKeyBio) then
    Result := _i2dPrivateKeyBio(B, pkey)
  else
    Result := 0;
end;

function EvpGetDigestByName(name: StringA): PEVP_MD;
begin
  if InitSSLInterface and Assigned(_EvpGetDigestByName) then
    Result := _EvpGetDigestByName(PCharA(Name))
  else
    Result := nil;
end;

function X509GetSerialNumber(x: pX509): PASN1_cInt;
begin
  if InitSSLInterface and Assigned(_X509GetSerialNumber) then
    Result := _X509GetSerialNumber(x)
  else
    Result := nil;
end;

// 3DES functions
procedure DESsetoddparity(key: DES_cblock);
begin
  if InitSSLInterface and Assigned(_DESsetoddparity) then
    _DESsetoddparity(key);
end;

function DESsetkey(key: DES_cblock; schedule: des_key_schedule): cint;
begin
  if InitSSLInterface and Assigned(_DESsetkey) then
    Result := _DESsetkey(key, schedule)
  else
    Result := -1;
end;

function DESsetkeychecked(key: DES_cblock; schedule: des_key_schedule): cint;
begin
  if InitSSLInterface and Assigned(_DESsetkeychecked) then
    Result := _DESsetkeychecked(key, schedule)
  else
    Result := -1;
end;

procedure DESecbencrypt(Input: DES_cblock; output: DES_cblock; ks: des_key_schedule; enc: cint);
begin
  if InitSSLInterface and Assigned(_DESecbencrypt) then
    _DESecbencrypt(Input, output, ks, enc);
end;

// RAND functions
function RAND_set_rand_method(const meth: PRAND_METHOD): cint;
begin
  if InitSSLInterface and Assigned(_RAND_set_rand_method) then
    Result := _RAND_set_rand_method(meth)
  else
    Result := -1;
end;

function RAND_get_rand_method: PRAND_METHOD;
begin
  if InitSSLInterface and Assigned(_RAND_get_rand_method) then
    Result := _RAND_get_rand_method()
  else
    Result := nil;
end;

function RAND_SSLeay: PRAND_METHOD;
begin
  if InitSSLInterface and Assigned(_RAND_SSLeay) then
    Result := _RAND_SSLeay()
  else
    Result := nil;
end;

procedure RAND_cleanup;
begin
  if InitSSLInterface and Assigned(_RAND_cleanup) then
    _RAND_cleanup();
end;

function RAND_bytes(buf: PByte; num: cint): cint;
begin
  if InitSSLInterface and Assigned(_RAND_bytes) then
    Result := _RAND_bytes(buf, num)
  else
    Result := -1;
end;

function RAND_pseudo_bytes(buf: PByte; num: cint): cint;
begin
  if InitSSLInterface and Assigned(_RAND_pseudo_bytes) then
    Result := _RAND_pseudo_bytes(buf, num)
  else
    Result := -1;
end;

procedure RAND_seed(const buf: Pointer; num: cint);
begin
  if InitSSLInterface and Assigned(_RAND_seed) then
    _RAND_seed(buf, num);
end;

procedure RAND_add(const buf: Pointer; num: cint; entropy: cdouble);
begin
  if InitSSLInterface and Assigned(_RAND_add) then
    _RAND_add(buf, num, entropy);
end;

function RAND_load_file(const file_name: PCharA; max_bytes: clong): cint;
begin
  if InitSSLInterface and Assigned(_RAND_load_file) then
    Result := _RAND_load_file(file_name, max_bytes)
  else
    Result := -1;
end;

function RAND_write_file(const file_name: PCharA): cint;
begin
  if InitSSLInterface and Assigned(_RAND_write_file) then
    Result := _RAND_write_file(file_name)
  else
    Result := -1;
end;

function RAND_file_name(file_name: PCharA; num: csize_t): PCharA;
begin
  if InitSSLInterface and Assigned(_RAND_file_name) then
    Result := _RAND_file_name(file_name, num)
  else
    Result := nil;
end;

function RAND_status: cint;
begin
  if InitSSLInterface and Assigned(_RAND_status) then
    Result := _RAND_status()
  else
    Result := -1;
end;

function RAND_query_egd_bytes(const path: PCharA; buf: PByte; bytes: cint): cint;
begin
  if InitSSLInterface and Assigned(_RAND_query_egd_bytes) then
    Result := _RAND_query_egd_bytes(path, buf, bytes)
  else
    Result := -1;
end;

function RAND_egd(const path: PCharA): cint;
begin
  if InitSSLInterface and Assigned(_RAND_egd) then
    Result := _RAND_egd(path)
  else
    Result := -1;
end;

function RAND_egd_bytes(const path: PCharA; bytes: cint): cint;
begin
  if InitSSLInterface and Assigned(_RAND_egd_bytes) then
    Result := _RAND_egd_bytes(path, bytes)
  else
    Result := -1;
end;

procedure ERR_load_RAND_strings;
begin
  if InitSSLInterface and Assigned(_ERR_load_RAND_strings) then
    _ERR_load_RAND_strings();
end;

function RAND_poll: cint;
begin
  if InitSSLInterface and Assigned(_RAND_poll) then
    Result := _RAND_poll()
  else
    Result := -1;
end;

// RSA Functions

function RSA_new(): PRSA;
begin
  if InitSSLInterface and Assigned(_RSA_new) then
    Result := _RSA_new()
  else
    Result := nil;
end;

function RSA_new_method(method: PENGINE): PRSA;
begin
  if InitSSLInterface and Assigned(_RSA_new_method) then
    Result := _RSA_new_method(method)
  else
    Result := nil;
end;

function RSA_size(arsa: PRSA): cint;
begin
  if InitSSLInterface and Assigned(_RSA_size) then
    Result := _RSA_size(arsa)
  else
    Result := -1;
end;

function RsaGenerateKey(bits, E: cint; callback: PFunction; cb_arg: SslPtr): PRSA;
begin
  if InitSSLInterface and Assigned(_RsaGenerateKey) then
    Result := _RsaGenerateKey(bits, E, callback, cb_arg)
  else
    Result := nil;
end;

function RSA_generate_key_ex(arsa: PRSA; bits: cint; E: PBIGNUM; cb: PBN_GENCB): PRSA;
begin
  if InitSSLInterface and Assigned(_RSA_generate_key_ex) then
    Result := _RSA_generate_key_ex(arsa, bits, E, cb)
  else
    Result := nil;
end;

function RSA_check_key(arsa: PRSA): cint;
begin
  if InitSSLInterface and Assigned(_RSA_check_key) then
    Result := _RSA_check_key(arsa)
  else
    Result := -1;
end;

function RSA_public_encrypt(flen: cint; from_buf, to_buf: PByte; arsa: PRSA; padding: cint): cint;
begin
  if InitSSLInterface and Assigned(_RSA_public_encrypt) then
    Result := _RSA_public_encrypt(flen, from_buf, to_buf, arsa, padding)
  else
    Result := -1;
end;

function RSA_private_encrypt(flen: cint; from_buf, to_buf: PByte; arsa: PRSA; padding: cint): cint;
begin
  if InitSSLInterface and Assigned(_RSA_private_encrypt) then
    Result := _RSA_private_encrypt(flen, from_buf, to_buf, arsa, padding)
  else
    Result := -1;
end;

function RSA_public_decrypt(flen: cint; from_buf, to_buf: PByte; arsa: PRSA; padding: cint): cint;
begin
  if InitSSLInterface and Assigned(_RSA_public_decrypt) then
    Result := _RSA_public_decrypt(flen, from_buf, to_buf, arsa, padding)
  else
    Result := -1;
end;

function RSA_private_decrypt(flen: cint; from_buf, to_buf: PByte; arsa: PRSA; padding: cint): cint;
begin
  if InitSSLInterface and Assigned(_RSA_private_decrypt) then
    Result := _RSA_private_decrypt(flen, from_buf, to_buf, arsa, padding)
  else
    Result := -1;
end;

procedure RSA_free(arsa: PRSA);
begin
  if InitSSLInterface and Assigned(_RSA_free) then
    _RSA_free(arsa);
end;

function RSA_flags(arsa: PRSA): integer;
begin
  if InitSSLInterface and Assigned(_RSA_flags) then
    Result := _RSA_flags(arsa)
  else
    Result := -1;
end;

procedure RSA_set_default_method(method: PRSA_METHOD);
begin
  if InitSSLInterface and Assigned(_RSA_set_default_method) then
    _RSA_set_default_method(method);
end;

function RSA_get_default_method: PRSA_METHOD;
begin
  if InitSSLInterface and Assigned(_RSA_get_default_method) then
    Result := _RSA_get_default_method()
  else
    Result := nil;
end;

function RSA_get_method(arsa: PRSA): PRSA_METHOD;
begin
  if InitSSLInterface and Assigned(_RSA_get_method) then
    Result := _RSA_get_method(arsa)
  else
    Result := nil;
end;

function RSA_set_method(arsa: PRSA; method: PRSA_METHOD): PRSA_METHOD;
begin
  if InitSSLInterface and Assigned(_RSA_set_method) then
    Result := _RSA_set_method(arsa, method)
  else
    Result := nil;
end;

function d2i_RSAPublicKey(arsa: PPRSA; pp: PPByte; len: cint): PRSA;
begin
  if InitSSLInterface and Assigned(_d2i_RSAPublicKey) then
    Result := _d2i_RSAPublicKey(arsa, pp, len)
  else
    Result := nil;
end;

function i2d_RSAPublicKey(arsa: PRSA; pp: PPByte): cint;
begin
  if InitSSLInterface and Assigned(_i2d_RSAPublicKey) then
    Result := _i2d_RSAPublicKey(arsa, pp)
  else
    Result := -1;
end;

function d2i_RSAPrivateKey(arsa: PPRSA; pp: PPByte; len: cint): PRSA;
begin
  if InitSSLInterface and Assigned(_d2i_RSAPrivateKey) then
    Result := _d2i_RSAPrivateKey(arsa, pp, len)
  else
    Result := nil;
end;

function i2d_RSAPrivateKey(arsa: PRSA; pp: PPByte): cint;
begin
  if InitSSLInterface and Assigned(_i2d_RSAPrivateKey) then
    Result := _i2d_RSAPrivateKey(arsa, pp)
  else
    Result := -1;
end;

// ERR Functions

function Err_Error_String(E: cint; buf: PCharA): PCharA;
begin
  if InitSSLInterface and Assigned(_Err_Error_String) then
    Result := _Err_Error_String(E, buf)
  else
    Result := nil;
end;

// Crypto Functions

function SSLeay_version(t: cint): PCharA;
begin
  if InitSSLInterface and Assigned(_SSLeay_version) then
    Result := _SSLeay_version(t)
  else
    Result := nil;
end;

// EVP Functions

function EVP_des_ede3_cbc: PEVP_CIPHER;
begin
  if InitSSLInterface and Assigned(_EVP_des_ede3_cbc) then
    Result := _EVP_des_ede3_cbc()
  else
    Result := Nil;
end;

function EVP_enc_null: PEVP_CIPHER;
begin
  if InitSSLInterface and Assigned(_EVP_enc_null) then
    Result := _EVP_enc_null()
  else
    Result := Nil;
end;

function EVP_rc2_cbc: PEVP_CIPHER;
begin
  if InitSSLInterface and Assigned(_EVP_rc2_cbc) then
    Result := _EVP_rc2_cbc()
  else
    Result := Nil;
end;

function EVP_rc2_40_cbc: PEVP_CIPHER;
begin
  if InitSSLInterface and Assigned(_EVP_rc2_40_cbc) then
    Result := _EVP_rc2_40_cbc()
  else
    Result := Nil;
end;

function EVP_rc2_64_cbc: PEVP_CIPHER;
begin
  if InitSSLInterface and Assigned(_EVP_rc2_64_cbc) then
    Result := _EVP_rc2_64_cbc()
  else
    Result := Nil;
end;

function EVP_rc4: PEVP_CIPHER;
begin
  if InitSSLInterface and Assigned(_EVP_rc4) then
    Result := _EVP_rc4()
  else
    Result := Nil;
end;

function EVP_rc4_40: PEVP_CIPHER;
begin
  if InitSSLInterface and Assigned(_EVP_rc4_40) then
    Result := _EVP_rc4_40()
  else
    Result := Nil;
end;

function EVP_des_cbc: PEVP_CIPHER;
begin
  if InitSSLInterface and Assigned(_EVP_des_cbc) then
    Result := _EVP_des_cbc()
  else
    Result := Nil;
end;

function EVP_aes_128_cbc: PEVP_CIPHER;
begin
  if InitSSLInterface and Assigned(_EVP_aes_128_cbc) then
    Result := _EVP_aes_128_cbc()
  else
    Result := Nil;
end;

function EVP_aes_192_cbc: PEVP_CIPHER;
begin
  if InitSSLInterface and Assigned(_EVP_aes_192_cbc) then
    Result := _EVP_aes_192_cbc()
  else
    Result := Nil;
end;

function EVP_aes_256_cbc: PEVP_CIPHER;
begin
  if InitSSLInterface and Assigned(_EVP_aes_256_cbc) then
    Result := _EVP_aes_256_cbc()
  else
    Result := Nil;
end;

function EVP_aes_128_cfb8: PEVP_CIPHER;
begin
  if InitSSLInterface and Assigned(_EVP_aes_128_cfb8) then
    Result := _EVP_aes_128_cfb8()
  else
    Result := Nil;
end;

function EVP_aes_192_cfb8: PEVP_CIPHER;
begin
  if InitSSLInterface and Assigned(_EVP_aes_192_cfb8) then
    Result := _EVP_aes_192_cfb8()
  else
    Result := Nil;
end;

function EVP_aes_256_cfb8: PEVP_CIPHER;
begin
  if InitSSLInterface and Assigned(_EVP_aes_256_cfb8) then
    Result := _EVP_aes_256_cfb8()
  else
    Result := Nil;
end;

function EVP_camellia_128_cbc: PEVP_CIPHER;
begin
  if InitSSLInterface and Assigned(_EVP_camellia_128_cbc) then
    Result := _EVP_camellia_128_cbc()
  else
    Result := Nil;
end;

function EVP_camellia_192_cbc: PEVP_CIPHER;
begin
  if InitSSLInterface and Assigned(_EVP_camellia_192_cbc) then
    Result := _EVP_camellia_192_cbc()
  else
    Result := Nil;
end;

function EVP_camellia_256_cbc: PEVP_CIPHER;
begin
  if InitSSLInterface and Assigned(_EVP_camellia_256_cbc) then
    Result := _EVP_camellia_256_cbc()
  else
    Result := Nil;
end;

procedure OpenSSL_add_all_algorithms;
begin
  if InitSSLInterface and Assigned(_OpenSSL_add_all_algorithms) then
    _OpenSSL_add_all_algorithms();
end;

procedure OpenSSL_add_all_ciphers;
begin
  if InitSSLInterface and Assigned(_OpenSSL_add_all_ciphers) then
    _OpenSSL_add_all_ciphers();
end;

procedure OpenSSL_add_all_digests;
begin
  if InitSSLInterface and Assigned(_OpenSSL_add_all_digests) then
    _OpenSSL_add_all_digests();
end;

//
function EVP_DigestInit(ctx: PEVP_MD_CTX; type_: PEVP_MD): cint;
begin
  if InitSSLInterface and Assigned(_EVP_DigestInit) then
    Result := _EVP_DigestInit(ctx, type_)
  else
    Result := -1;
end;

function EVP_DigestUpdate(ctx: PEVP_MD_CTX; const data: Pointer; cnt: csize_t): cint;
begin
  if InitSSLInterface and Assigned(_EVP_DigestUpdate) then
    Result := _EVP_DigestUpdate(ctx, data, cnt)
  else
    Result := -1;
end;

function EVP_DigestFinal(ctx: PEVP_MD_CTX; md: PByte; s: pcuint): cint;
begin
  if InitSSLInterface and Assigned(_EVP_DigestFinal) then
    Result := _EVP_DigestFinal(ctx, md, s)
  else
    Result := -1;
end;

function EVP_SignFinal(ctx: PEVP_MD_CTX; sig: Pointer; var s: cardinal; key: PEVP_PKEY): integer;
begin
  if InitSSLInterface and Assigned(_EVP_SignFinal) then
    Result := _EVP_SignFinal(ctx, sig, s, key)
  else
    Result := -1;
end;

function EVP_PKEY_size(key: PEVP_PKEY): integer;
begin
  if InitSSLInterface and Assigned(_EVP_PKEY_size) then
    Result := _EVP_PKEY_size(key)
  else
    Result := -1;
end;

procedure EVP_PKEY_free(key: PEVP_PKEY);
begin
  if InitSSLInterface and Assigned(_EVP_PKEY_free) then
    _EVP_PKEY_free(key);
end;

function EVP_VerifyFinal(ctx: PEVP_MD_CTX; sigbuf: Pointer; siglen: cardinal; pkey: PEVP_PKEY): integer;
begin
  if InitSSLInterface and Assigned(_EVP_VerifyFinal) then
    Result := _EVP_VerifyFinal(ctx, sigbuf, siglen, pkey)
  else
    Result := -1;
end;

//
function EVP_get_cipherbyname(const name: PCharA): PEVP_CIPHER;
begin
  if InitSSLInterface and Assigned(_EVP_get_cipherbyname) then
    Result := _EVP_get_cipherbyname(name)
  else
    Result := nil;
end;

function EVP_get_digestbyname(const name: PCharA): PEVP_MD;
begin
  if InitSSLInterface and Assigned(_EVP_get_digestbyname) then
    Result := _EVP_get_digestbyname(name)
  else
    Result := nil;
end;

//
procedure EVP_CIPHER_CTX_init(A: PEVP_CIPHER_CTX);
begin
  if InitSSLInterface and Assigned(_EVP_CIPHER_CTX_init) then
    _EVP_CIPHER_CTX_init(A);
end;

function EVP_CIPHER_CTX_cleanup(A: PEVP_CIPHER_CTX): cint;
begin
  if InitSSLInterface and Assigned(_EVP_CIPHER_CTX_cleanup) then
    Result := _EVP_CIPHER_CTX_cleanup(A)
  else
    Result := -1;
end;

function EVP_CIPHER_CTX_set_key_length(x: PEVP_CIPHER_CTX; keylen: cint): cint;
begin
  if InitSSLInterface and Assigned(_EVP_CIPHER_CTX_set_key_length) then
    Result := _EVP_CIPHER_CTX_set_key_length(x, keylen)
  else
    Result := -1;
end;

function EVP_CIPHER_CTX_ctrl(ctx: PEVP_CIPHER_CTX; type_, arg: cint; ptr: Pointer): cint;
begin
  if InitSSLInterface and Assigned(_EVP_CIPHER_CTX_ctrl) then
    Result := _EVP_CIPHER_CTX_ctrl(ctx, type_, arg, ptr)
  else
    Result := -1;
end;

//
function EVP_EncryptInit(ctx: PEVP_CIPHER_CTX; const chipher_: PEVP_CIPHER; const key, iv: PByte): cint;
begin
  if InitSSLInterface and Assigned(_EVP_EncryptInit) then
    Result := _EVP_EncryptInit(ctx, chipher_, key, iv)
  else
    Result := -1;
end;

function EVP_EncryptUpdate(ctx: PEVP_CIPHER_CTX; out_: pcuchar; outlen: pcint; const in_: pcuchar; inlen: cint): cint;
begin
  if InitSSLInterface and Assigned(_EVP_EncryptUpdate) then
    Result := _EVP_EncryptUpdate(ctx, out_, outlen, in_, inlen)
  else
    Result := -1;
end;

function EVP_EncryptFinal(ctx: PEVP_CIPHER_CTX; out_data: PByte; outlen: pcint): cint;
begin
  if InitSSLInterface and Assigned(_EVP_EncryptFinal) then
    Result := _EVP_EncryptFinal(ctx, out_data, outlen)
  else
    Result := -1;
end;

//
function EVP_DecryptInit(ctx: PEVP_CIPHER_CTX; chiphir_type: PEVP_CIPHER; const key, iv: PByte): cint;
begin
  if InitSSLInterface and Assigned(_EVP_DecryptInit) then
    Result := _EVP_DecryptInit(ctx, chiphir_type, key, iv)
  else
    Result := -1;
end;

function EVP_DecryptUpdate(ctx: PEVP_CIPHER_CTX; out_data: PByte; outl: pcint; const in_: PByte; inl: cint): cint;
begin
  if InitSSLInterface and Assigned(_EVP_DecryptUpdate) then
    Result := _EVP_DecryptUpdate(ctx, out_data, outl, in_, inl)
  else
    Result := -1;
end;

function EVP_DecryptFinal(ctx: PEVP_CIPHER_CTX; outm: PByte; outlen: pcint): cint;
begin
  if InitSSLInterface and Assigned(_EVP_DecryptFinal) then
    Result := _EVP_DecryptFinal(ctx, outm, outlen)
  else
    Result := -1;
end;

{ PEM }

function PEM_read_bio_PrivateKey(bp: PBIO; x: PPEVP_PKEY; cb: Ppem_password_cb; u: Pointer): PEVP_PKEY;
begin
  if InitSSLInterface and Assigned(_PEM_read_bio_PrivateKey) then
    Result := _PEM_read_bio_PrivateKey(bp, x, cb, u)
  else
    Result := nil;
end;

function PEM_read_bio_PUBKEY(bp: PBIO; var x: PEVP_PKEY; cb: Ppem_password_cb; u: Pointer): PEVP_PKEY;
begin
  if InitSSLInterface and Assigned(_PEM_read_bio_PUBKEY) then
    Result := _PEM_read_bio_PUBKEY(bp, x, cb, u)
  else
    Result := nil;
end;

function PEM_write_bio_PrivateKey(bp: PBIO; x: PEVP_PKEY; const enc: PEVP_CIPHER; kstr: PCharA; klen: integer;
  cb: Ppem_password_cb; u: Pointer): integer;
Begin
  if InitSSLInterface and Assigned(_PEM_write_bio_PrivateKey) then
    Result := _PEM_write_bio_PrivateKey(bp, x, enc, kstr, klen, cb, u)
  else
    Result := -1;
end;

function PEM_write_bio_PUBKEY(bp: PBIO; x: PEVP_PKEY): integer;
Begin
  if InitSSLInterface and Assigned(_PEM_write_bio_PUBKEY) then
    Result := _PEM_write_bio_PUBKEY(bp, x)
  else
    Result := -1;
end;

// BIO Functions

function BIO_ctrl(bp: PBIO; cmd: cint; larg: clong; parg: Pointer): clong;
begin
  if InitSSLInterface and Assigned(_BIO_ctrl) then
    Result := _BIO_ctrl(bp, cmd, larg, parg)
  else
    Result := -1;
end;

function BIO_read_filename(B: PBIO; const name: PCharA): cint;
begin
  Result := BIO_ctrl(B, BIO_C_SET_FILENAME, BIO_CLOSE or BIO_FP_READ, name);
end;

function BIO_s_file: PBIO_METHOD;
begin
  if InitSSLInterface and Assigned(_BIO_s_file) then
    Result := _BIO_s_file
  else
    Result := nil;
end;

function BIO_new_file(const filename: PCharA; const mode: PCharA): PBIO;
begin
  if InitSSLInterface and Assigned(_BIO_new_file) then
    Result := _BIO_new_file(filename, mode)
  else
    Result := nil;
end;

function BIO_new_mem_buf(buf: Pointer; len: integer): PBIO;
begin
  if InitSSLInterface and Assigned(_BIO_new_mem_buf) then
    Result := _BIO_new_mem_buf(buf, len)
  else
    Result := nil;
end;

procedure CRYPTOcleanupAllExData;
begin
  if InitSSLInterface and Assigned(_CRYPTOcleanupAllExData) then
    _CRYPTOcleanupAllExData;
end;

procedure OPENSSLaddallalgorithms;
begin
  if InitSSLInterface and Assigned(_OPENSSLaddallalgorithms) then
    _OPENSSLaddallalgorithms;
end;

function LoadLib(const Value: string): HModule;
begin
  Result := LoadLibrary(PChar(Value));
end;

function GetProcAddr(module: HModule; const ProcName: string): SslPtr;
begin
  Result := GetProcAddress(module, PChar(ProcName));
  if LoadVerbose and (Result = nil) then
    OpenSSL_unavailable_functions := OpenSSL_unavailable_functions + ProcName + LineEnding;
end;

// The AVerboseLoading parameter can be used to check which particular
// functions weren't loaded correctly. They will be available in the
// global variable OpenSSL_unavailable_functions

function IsSSLloaded: Boolean;

begin
  Result := SSLloaded;
end;

Procedure LoadSSLEntryPoints;

begin
  _SslGetError := GetProcAddr(SSLLibHandle, 'SSL_get_error');
  _SslLibraryInit := GetProcAddr(SSLLibHandle, 'SSL_library_init');
  _SslLoadErrorStrings := GetProcAddr(SSLLibHandle, 'SSL_load_error_strings');
  _SslCtxSetCipherList := GetProcAddr(SSLLibHandle, 'SSL_CTX_set_cipher_list');
  _SslCtxNew := GetProcAddr(SSLLibHandle, 'SSL_CTX_new');
  _SslCtxFree := GetProcAddr(SSLLibHandle, 'SSL_CTX_free');
  _SslSetFd := GetProcAddr(SSLLibHandle, 'SSL_set_fd');
  _SslCtrl := GetProcAddr(SSLLibHandle, 'SSL_ctrl');
  _SslCTXCtrl := GetProcAddr(SSLLibHandle, 'SSL_CTX_ctrl');
  _SslMethodV2 := GetProcAddr(SSLLibHandle, 'SSLv2_method');
  _SslMethodV3 := GetProcAddr(SSLLibHandle, 'SSLv3_method');
  _SslMethodTLSV1 := GetProcAddr(SSLLibHandle, 'TLSv1_method');
  _SslMethodV23 := GetProcAddr(SSLLibHandle, 'SSLv23_method');
  _SslCtxUsePrivateKey := GetProcAddr(SSLLibHandle, 'SSL_CTX_use_PrivateKey');
  _SslCtxUsePrivateKeyASN1 := GetProcAddr(SSLLibHandle, 'SSL_CTX_use_PrivateKey_ASN1');
  // use SSL_CTX_use_RSAPrivateKey_file instead SSL_CTX_use_PrivateKey_file,
  // because SSL_CTX_use_PrivateKey_file not support DER format. :-O
  _SslCtxUsePrivateKeyFile := GetProcAddr(SSLLibHandle, 'SSL_CTX_use_RSAPrivateKey_file');
  _SslCtxUseCertificate := GetProcAddr(SSLLibHandle, 'SSL_CTX_use_certificate');
  _SslCtxUseCertificateASN1 := GetProcAddr(SSLLibHandle, 'SSL_CTX_use_certificate_ASN1');
  _SslCtxUseCertificateFile := GetProcAddr(SSLLibHandle, 'SSL_CTX_use_certificate_file');
  _SslCtxUseCertificateChainFile := GetProcAddr(SSLLibHandle, 'SSL_CTX_use_certificate_chain_file');
  _SslCtxCheckPrivateKeyFile := GetProcAddr(SSLLibHandle, 'SSL_CTX_check_private_key');
  _SslCtxSetDefaultPasswdCb := GetProcAddr(SSLLibHandle, 'SSL_CTX_set_default_passwd_cb');
  _SslCtxSetDefaultPasswdCbUserdata := GetProcAddr(SSLLibHandle, 'SSL_CTX_set_default_passwd_cb_userdata');
  _SslCtxLoadVerifyLocations := GetProcAddr(SSLLibHandle, 'SSL_CTX_load_verify_locations');
  _SslNew := GetProcAddr(SSLLibHandle, 'SSL_new');
  _SslFree := GetProcAddr(SSLLibHandle, 'SSL_free');
  _SslAccept := GetProcAddr(SSLLibHandle, 'SSL_accept');
  _SslConnect := GetProcAddr(SSLLibHandle, 'SSL_connect');
  _SslShutdown := GetProcAddr(SSLLibHandle, 'SSL_shutdown');
  _SslRead := GetProcAddr(SSLLibHandle, 'SSL_read');
  _SslPeek := GetProcAddr(SSLLibHandle, 'SSL_peek');
  _SslWrite := GetProcAddr(SSLLibHandle, 'SSL_write');
  _SslPending := GetProcAddr(SSLLibHandle, 'SSL_pending');
  _SslGetPeerCertificate := GetProcAddr(SSLLibHandle, 'SSL_get_peer_certificate');
  _SslGetVersion := GetProcAddr(SSLLibHandle, 'SSL_get_version');
  _SslCtxSetVerify := GetProcAddr(SSLLibHandle, 'SSL_CTX_set_verify');
  _SSLGetCurrentCipher := GetProcAddr(SSLLibHandle, 'SSL_get_current_cipher');
  _SSLCipherGetName := GetProcAddr(SSLLibHandle, 'SSL_CIPHER_get_name');
  _SSLCipherGetBits := GetProcAddr(SSLLibHandle, 'SSL_CIPHER_get_bits');
  _SSLGetVerifyResult := GetProcAddr(SSLLibHandle, 'SSL_get_verify_result');
end;

Procedure LoadUtilEntryPoints;

begin
  _ERR_load_crypto_strings := GetProcAddr(SSLUtilHandle, 'ERR_load_crypto_strings');
  _X509New := GetProcAddr(SSLUtilHandle, 'X509_new');
  _X509Free := GetProcAddr(SSLUtilHandle, 'X509_free');
  _X509NameOneline := GetProcAddr(SSLUtilHandle, 'X509_NAME_oneline');
  _X509GetSubjectName := GetProcAddr(SSLUtilHandle, 'X509_get_subject_name');
  _X509GetIssuerName := GetProcAddr(SSLUtilHandle, 'X509_get_issuer_name');
  _X509NameHash := GetProcAddr(SSLUtilHandle, 'X509_NAME_hash');
  _X509Digest := GetProcAddr(SSLUtilHandle, 'X509_digest');
  _X509print := GetProcAddr(SSLUtilHandle, 'X509_print');
  _X509SetVersion := GetProcAddr(SSLUtilHandle, 'X509_set_version');
  _X509SetPubkey := GetProcAddr(SSLUtilHandle, 'X509_set_pubkey');
  _X509SetIssuerName := GetProcAddr(SSLUtilHandle, 'X509_set_issuer_name');
  _X509NameAddEntryByTxt := GetProcAddr(SSLUtilHandle, 'X509_NAME_add_entry_by_txt');
  _X509Sign := GetProcAddr(SSLUtilHandle, 'X509_sign');
  _X509GmtimeAdj := GetProcAddr(SSLUtilHandle, 'X509_gmtime_adj');
  _X509SetNotBefore := GetProcAddr(SSLUtilHandle, 'X509_set_notBefore');
  _X509SetNotAfter := GetProcAddr(SSLUtilHandle, 'X509_set_notAfter');
  _X509GetSerialNumber := GetProcAddr(SSLUtilHandle, 'X509_get_serialNumber');
  _EvpPkeyNew := GetProcAddr(SSLUtilHandle, 'EVP_PKEY_new');
  _EvpPkeyFree := GetProcAddr(SSLUtilHandle, 'EVP_PKEY_free');
  _EvpPkeyAssign := GetProcAddr(SSLUtilHandle, 'EVP_PKEY_assign');
  _EVPcleanup := GetProcAddr(SSLUtilHandle, 'EVP_cleanup');
  _EvpGetDigestByName := GetProcAddr(SSLUtilHandle, 'EVP_get_digestbyname');
  _SSLeayversion := GetProcAddr(SSLUtilHandle, 'SSLeay_version');
  _ErrErrorString := GetProcAddr(SSLUtilHandle, 'ERR_error_string_n');
  _ErrGetError := GetProcAddr(SSLUtilHandle, 'ERR_get_error');
  _ErrClearError := GetProcAddr(SSLUtilHandle, 'ERR_clear_error');
  _ErrFreeStrings := GetProcAddr(SSLUtilHandle, 'ERR_free_strings');
  _ErrRemoveState := GetProcAddr(SSLUtilHandle, 'ERR_remove_state');
  _RandScreen := GetProcAddr(SSLUtilHandle, 'RAND_screen');
  _BioNew := GetProcAddr(SSLUtilHandle, 'BIO_new');
  _BioFreeAll := GetProcAddr(SSLUtilHandle, 'BIO_free_all');
  _BioSMem := GetProcAddr(SSLUtilHandle, 'BIO_s_mem');
  _BioCtrlPending := GetProcAddr(SSLUtilHandle, 'BIO_ctrl_pending');
  _BioRead := GetProcAddr(SSLUtilHandle, 'BIO_read');
  _BioWrite := GetProcAddr(SSLUtilHandle, 'BIO_write');
  _d2iPKCS12bio := GetProcAddr(SSLUtilHandle, 'd2i_PKCS12_bio');
  _PKCS12parse := GetProcAddr(SSLUtilHandle, 'PKCS12_parse');
  _PKCS12free := GetProcAddr(SSLUtilHandle, 'PKCS12_free');
  _Asn1UtctimeNew := GetProcAddr(SSLUtilHandle, 'ASN1_UTCTIME_new');
  _Asn1UtctimeFree := GetProcAddr(SSLUtilHandle, 'ASN1_UTCTIME_free');
  _Asn1IntegerSet := GetProcAddr(SSLUtilHandle, 'ASN1_INTEGER_set');
  _Asn1IntegerGet := GetProcAddr(SSLUtilHandle, 'ASN1_INTEGER_get');
  _i2dX509bio := GetProcAddr(SSLUtilHandle, 'i2d_X509_bio');
  _i2dPrivateKeyBio := GetProcAddr(SSLUtilHandle, 'i2d_PrivateKey_bio');
  _EVP_enc_null := GetProcAddr(SSLUtilHandle, 'EVP_enc_null');
  _EVP_rc2_cbc := GetProcAddr(SSLUtilHandle, 'EVP_rc2_cbc');
  _EVP_rc2_40_cbc := GetProcAddr(SSLUtilHandle, 'EVP_rc2_40_cbc');
  _EVP_rc2_64_cbc := GetProcAddr(SSLUtilHandle, 'EVP_rc2_64_cbc');
  _EVP_rc4 := GetProcAddr(SSLUtilHandle, 'EVP_rc4');
  _EVP_rc4_40 := GetProcAddr(SSLUtilHandle, 'EVP_rc4_40');
  _EVP_des_cbc := GetProcAddr(SSLUtilHandle, 'EVP_des_cbc');
  _EVP_des_ede3_cbc := GetProcAddr(SSLUtilHandle, 'EVP_des_ede3_cbc');
  _EVP_aes_128_cbc := GetProcAddr(SSLUtilHandle, 'EVP_aes_128_cbc');
  _EVP_aes_192_cbc := GetProcAddr(SSLUtilHandle, 'EVP_aes_192_cbc');
  _EVP_aes_256_cbc := GetProcAddr(SSLUtilHandle, 'EVP_aes_256_cbc');
  _EVP_aes_128_cfb8 := GetProcAddr(SSLUtilHandle, 'EVP_aes_128_cfb8');
  _EVP_aes_192_cfb8 := GetProcAddr(SSLUtilHandle, 'EVP_aes_192_cfb8');
  _EVP_aes_256_cfb8 := GetProcAddr(SSLUtilHandle, 'EVP_aes_256_cfb8');
  _EVP_camellia_128_cbc := GetProcAddr(SSLUtilHandle, 'EVP_camellia_128_cbc');
  _EVP_camellia_192_cbc := GetProcAddr(SSLUtilHandle, 'EVP_camellia_192_cbc');
  _EVP_camellia_256_cbc := GetProcAddr(SSLUtilHandle, 'EVP_camellia_256_cbc');
  // 3DES functions
  _DESsetoddparity := GetProcAddr(SSLUtilHandle, 'des_set_odd_parity');
  _DESsetkeychecked := GetProcAddr(SSLUtilHandle, 'des_set_key_checked');
  _DESsetkey := GetProcAddr(SSLUtilHandle, 'des_set_key');
  _DESecbencrypt := GetProcAddr(SSLUtilHandle, 'des_ecb_encrypt');
  //
  _CRYPTOnumlocks := GetProcAddr(SSLUtilHandle, 'CRYPTO_num_locks');
  _CRYPTOSetLockingCallback := GetProcAddr(SSLUtilHandle, 'CRYPTO_set_locking_callback');
  // RAND functions
  _RAND_set_rand_method := GetProcAddr(SSLUtilHandle, 'RAND_set_rand_method');
  _RAND_get_rand_method := GetProcAddr(SSLUtilHandle, 'RAND_get_rand_method');
  _RAND_SSLeay := GetProcAddr(SSLUtilHandle, 'RAND_SSLeay');
  _RAND_cleanup := GetProcAddr(SSLUtilHandle, 'RAND_cleanup');
  _RAND_bytes := GetProcAddr(SSLUtilHandle, 'RAND_bytes');
  _RAND_pseudo_bytes := GetProcAddr(SSLUtilHandle, 'RAND_pseudo_bytes');
  _RAND_seed := GetProcAddr(SSLUtilHandle, 'RAND_seed');
  _RAND_add := GetProcAddr(SSLUtilHandle, 'RAND_add');
  _RAND_load_file := GetProcAddr(SSLUtilHandle, 'RAND_load_file');
  _RAND_write_file := GetProcAddr(SSLUtilHandle, 'RAND_write_file');
  _RAND_file_name := GetProcAddr(SSLUtilHandle, 'RAND_file_name');
  _RAND_status := GetProcAddr(SSLUtilHandle, 'RAND_status');
  _RAND_query_egd_bytes := GetProcAddr(SSLUtilHandle, 'RAND_query_egd_bytes'); // 0.9.7+
  _RAND_egd := GetProcAddr(SSLUtilHandle, 'RAND_egd');
  _RAND_egd_bytes := GetProcAddr(SSLUtilHandle, 'RAND_egd_bytes');
  _ERR_load_RAND_strings := GetProcAddr(SSLUtilHandle, 'ERR_load_RAND_strings');
  _RAND_poll := GetProcAddr(SSLUtilHandle, 'RAND_poll');
  // RSA Functions
  _RSA_new := GetProcAddr(SSLUtilHandle, 'RSA_new');
  _RSA_new_method := GetProcAddr(SSLUtilHandle, 'RSA_new_method');
  _RSA_size := GetProcAddr(SSLUtilHandle, 'RSA_size');
  _RsaGenerateKey := GetProcAddr(SSLUtilHandle, 'RSA_generate_key');
  _RSA_generate_key_ex := GetProcAddr(SSLUtilHandle, 'RSA_generate_key_ex');
  _RSA_check_key := GetProcAddr(SSLUtilHandle, 'RSA_check_key');
  _RSA_public_encrypt := GetProcAddr(SSLUtilHandle, 'RSA_public_encrypt');
  _RSA_private_encrypt := GetProcAddr(SSLUtilHandle, 'RSA_private_encrypt');
  _RSA_public_decrypt := GetProcAddr(SSLUtilHandle, 'RSA_public_decrypt');
  _RSA_private_decrypt := GetProcAddr(SSLUtilHandle, 'RSA_private_decrypt');
  _RSA_free := GetProcAddr(SSLUtilHandle, 'RSA_free');
  _RSA_flags := GetProcAddr(SSLUtilHandle, 'RSA_flags');
  _RSA_set_default_method := GetProcAddr(SSLUtilHandle, 'RSA_set_default_method');
  _RSA_get_default_method := GetProcAddr(SSLUtilHandle, 'RSA_get_default_method');
  _RSA_get_method := GetProcAddr(SSLUtilHandle, 'RSA_get_method');
  _RSA_set_method := GetProcAddr(SSLUtilHandle, 'RSA_set_method');
  // X509 Functions
  _d2i_RSAPublicKey := GetProcAddr(SSLUtilHandle, 'd2i_RSAPublicKey');
  _i2d_RSAPublicKey := GetProcAddr(SSLUtilHandle, 'i2d_RSAPublicKey');
  _d2i_RSAPrivateKey := GetProcAddr(SSLUtilHandle, 'd2i_RSAPrivateKey');
  _i2d_RSAPrivateKey := GetProcAddr(SSLUtilHandle, 'i2d_RSAPrivateKey');
  // ERR Functions
  _Err_Error_String := GetProcAddr(SSLUtilHandle, 'ERR_error_string');
  // EVP Functions
  _OpenSSL_add_all_algorithms := GetProcAddr(SSLUtilHandle, 'OpenSSL_add_all_algorithms');
  _OpenSSL_add_all_ciphers := GetProcAddr(SSLUtilHandle, 'OpenSSL_add_all_ciphers');
  _OpenSSL_add_all_digests := GetProcAddr(SSLUtilHandle, 'OpenSSL_add_all_digests');
  _EVP_DigestInit := GetProcAddr(SSLUtilHandle, 'EVP_DigestInit');
  _EVP_DigestUpdate := GetProcAddr(SSLUtilHandle, 'EVP_DigestUpdate');
  _EVP_DigestFinal := GetProcAddr(SSLUtilHandle, 'EVP_DigestFinal');
  _EVP_SignFinal := GetProcAddr(SSLUtilHandle, 'EVP_SignFinal');
  _EVP_PKEY_size := GetProcAddr(SSLUtilHandle, 'EVP_PKEY_size');
  _EVP_PKEY_free := GetProcAddr(SSLUtilHandle, 'EVP_PKEY_free');
  _EVP_VerifyFinal := GetProcAddr(SSLUtilHandle, 'EVP_VerifyFinal');
  _EVP_get_cipherbyname := GetProcAddr(SSLUtilHandle, 'EVP_get_cipherbyname');
  _EVP_get_digestbyname := GetProcAddr(SSLUtilHandle, 'EVP_get_digestbyname');
  _EVP_CIPHER_CTX_init := GetProcAddr(SSLUtilHandle, 'EVP_CIPHER_CTX_init');
  _EVP_CIPHER_CTX_cleanup := GetProcAddr(SSLUtilHandle, 'EVP_CIPHER_CTX_cleanup');
  _EVP_CIPHER_CTX_set_key_length := GetProcAddr(SSLUtilHandle, 'EVP_CIPHER_CTX_set_key_length');
  _EVP_CIPHER_CTX_ctrl := GetProcAddr(SSLUtilHandle, 'EVP_CIPHER_CTX_ctrl');
  _EVP_EncryptInit := GetProcAddr(SSLUtilHandle, 'EVP_EncryptInit');
  _EVP_EncryptUpdate := GetProcAddr(SSLUtilHandle, 'EVP_EncryptUpdate');
  _EVP_EncryptFinal := GetProcAddr(SSLUtilHandle, 'EVP_EncryptFinal');
  _EVP_DecryptInit := GetProcAddr(SSLUtilHandle, 'EVP_DecryptInit');
  _EVP_DecryptUpdate := GetProcAddr(SSLUtilHandle, 'EVP_DecryptUpdate');
  _EVP_DecryptFinal := GetProcAddr(SSLUtilHandle, 'EVP_DecryptFinal');
  // PEM
  _PEM_read_bio_PrivateKey := GetProcAddr(SSLUtilHandle, 'PEM_read_bio_PrivateKey');
  _PEM_read_bio_PUBKEY := GetProcAddr(SSLUtilHandle, 'PEM_read_bio_PUBKEY');
  _PEM_write_bio_PrivateKey := GetProcAddr(SSLUtilHandle, 'PEM_write_bio_PrivateKey');
  _PEM_write_bio_PUBKEY := GetProcAddr(SSLUtilHandle, 'PEM_write_bio_PUBKEY');
  // BIO
  _BIO_ctrl := GetProcAddr(SSLUtilHandle, 'BIO_ctrl');
  _BIO_s_file := GetProcAddr(SSLUtilHandle, 'BIO_s_file');
  _BIO_new_file := GetProcAddr(SSLUtilHandle, 'BIO_new_file');
  _BIO_new_mem_buf := GetProcAddr(SSLUtilHandle, 'BIO_new_mem_buf');
  // Crypto Functions
  _SSLeay_version := GetProcAddr(SSLUtilHandle, 'SSLeay_version');
end;

Function LoadUtilLibrary: Boolean;
var
  I: integer;

begin
  Result := (SSLUtilHandle <> 0);
  if not Result then
  begin
    for I := Low(DLLUtilNames) to High(DLLUtilNames) do
    begin
      SSLUtilHandle := LoadLib(DLLUtilNames[I]);
      Result := (SSLUtilHandle <> 0);
      if Result then
        Break;
    end;
  end;
end;

Procedure ClearSSLEntryPoints;

begin
  _SslGetError := nil;
  _SslLibraryInit := nil;
  _SslLoadErrorStrings := nil;
  _SslCtxSetCipherList := nil;
  _SslCtxNew := nil;
  _SslCtxFree := nil;
  _SslSetFd := nil;
  _SslCtrl := nil;
  _SslCTXCtrl := nil;
  _SslMethodV2 := nil;
  _SslMethodV3 := nil;
  _SslMethodTLSV1 := nil;
  _SslMethodV23 := nil;
  _SslCtxUsePrivateKey := nil;
  _SslCtxUsePrivateKeyASN1 := nil;
  _SslCtxUsePrivateKeyFile := nil;
  _SslCtxUseCertificate := nil;
  _SslCtxUseCertificateASN1 := nil;
  _SslCtxUseCertificateFile := nil;
  _SslCtxUseCertificateChainFile := nil;
  _SslCtxCheckPrivateKeyFile := nil;
  _SslCtxSetDefaultPasswdCb := nil;
  _SslCtxSetDefaultPasswdCbUserdata := nil;
  _SslCtxLoadVerifyLocations := nil;
  _SslNew := nil;
  _SslFree := nil;
  _SslAccept := nil;
  _SslConnect := nil;
  _SslShutdown := nil;
  _SslRead := nil;
  _SslPeek := nil;
  _SslWrite := nil;
  _SslPending := nil;
  _SslGetPeerCertificate := nil;
  _SslGetVersion := nil;
  _SslCtxSetVerify := nil;
  _SSLGetCurrentCipher := nil;
  _SSLCipherGetName := nil;
  _SSLCipherGetBits := nil;
  _SSLGetVerifyResult := nil;
end;

Procedure UnloadSSLLib;

begin
  if (SSLLibHandle <> 0) then
  begin
    FreeLibrary(SSLLibHandle);
    SSLLibHandle := 0;
  end;
end;

Procedure UnloadUtilLib;

begin
  if (SSLUtilHandle <> 0) then
  begin
    FreeLibrary(SSLUtilHandle);
    SSLUtilHandle := 0;
  end;
end;

Procedure ClearUtilEntryPoints;

begin
  _SSLeayversion := nil;
  _ERR_load_crypto_strings := nil;
  _X509New := nil;
  _X509Free := nil;
  _X509NameOneline := nil;
  _X509GetSubjectName := nil;
  _X509GetIssuerName := nil;
  _X509NameHash := nil;
  _X509Digest := nil;
  _X509print := nil;
  _X509SetVersion := nil;
  _X509SetPubkey := nil;
  _X509SetIssuerName := nil;
  _X509NameAddEntryByTxt := nil;
  _X509Sign := nil;
  _X509GmtimeAdj := nil;
  _X509SetNotBefore := nil;
  _X509SetNotAfter := nil;
  _X509GetSerialNumber := nil;
  _EvpPkeyNew := nil;
  _EvpPkeyFree := nil;
  _EvpPkeyAssign := nil;
  _EVPcleanup := nil;
  _EvpGetDigestByName := nil;
  _ErrErrorString := nil;
  _ErrGetError := nil;
  _ErrClearError := nil;
  _ErrFreeStrings := nil;
  _ErrRemoveState := nil;
  _RandScreen := nil;
  _BioNew := nil;
  _BioFreeAll := nil;
  _BioSMem := nil;
  _BioCtrlPending := nil;
  _BioRead := nil;
  _BioWrite := nil;
  _d2iPKCS12bio := nil;
  _PKCS12parse := nil;
  _PKCS12free := nil;
  _Asn1UtctimeNew := nil;
  _Asn1UtctimeFree := nil;
  _Asn1IntegerSet := nil;
  _Asn1IntegerGet := nil;
  _i2dX509bio := nil;
  _i2dPrivateKeyBio := nil;

  // 3DES functions
  _DESsetoddparity := nil;
  _DESsetkeychecked := nil;
  _DESecbencrypt := nil;
  //
  _CRYPTOnumlocks := nil;
  _CRYPTOSetLockingCallback := nil;

  // RAND functions
  _RAND_set_rand_method := nil;
  _RAND_get_rand_method := nil;
  _RAND_SSLeay := nil;
  _RAND_cleanup := nil;
  _RAND_bytes := nil;
  _RAND_pseudo_bytes := nil;
  _RAND_seed := nil;
  _RAND_add := nil;
  _RAND_load_file := nil;
  _RAND_write_file := nil;
  _RAND_file_name := nil;
  _RAND_status := nil;
  _RAND_query_egd_bytes := nil;
  _RAND_egd := nil;
  _RAND_egd_bytes := nil;
  _ERR_load_RAND_strings := nil;
  _RAND_poll := nil;

  // RSA Functions
  _RSA_new := nil;
  _RSA_new_method := nil;
  _RSA_size := nil;
  _RsaGenerateKey := nil;
  _RSA_generate_key_ex := nil;
  _RSA_check_key := nil;
  _RSA_public_encrypt := nil;
  _RSA_private_encrypt := nil;
  _RSA_public_decrypt := nil;
  _RSA_private_decrypt := nil;
  _RSA_free := nil;
  _RSA_flags := nil;
  _RSA_set_default_method := nil;
  _RSA_get_default_method := nil;
  _RSA_get_method := nil;
  _RSA_set_method := nil;

  // X509 Functions

  _d2i_RSAPublicKey := nil;
  _i2d_RSAPublicKey := nil;
  _d2i_RSAPrivateKey := nil;
  _i2d_RSAPrivateKey := nil;

  // ERR Functions
  _Err_Error_String := nil;

  // EVP Functions

  _OpenSSL_add_all_algorithms := nil;
  _OpenSSL_add_all_ciphers := nil;
  _OpenSSL_add_all_digests := nil;
  //
  _EVP_DigestInit := nil;
  _EVP_DigestUpdate := nil;
  _EVP_DigestFinal := nil;

  _EVP_SignFinal := nil;
  _EVP_PKEY_size := nil;
  _EVP_PKEY_free := nil;
  _EVP_VerifyFinal := nil;
  //
  _EVP_get_cipherbyname := nil;
  _EVP_get_digestbyname := nil;
  //
  _EVP_CIPHER_CTX_init := nil;
  _EVP_CIPHER_CTX_cleanup := nil;
  _EVP_CIPHER_CTX_set_key_length := nil;
  _EVP_CIPHER_CTX_ctrl := nil;
  //
  _EVP_EncryptInit := nil;
  _EVP_EncryptUpdate := nil;
  _EVP_EncryptFinal := nil;
  //
  _EVP_DecryptInit := nil;
  _EVP_DecryptUpdate := nil;
  _EVP_DecryptFinal := nil;

  // PEM

  _PEM_read_bio_PrivateKey := nil;
  _PEM_read_bio_PrivateKey := nil;
  _PEM_read_bio_PUBKEY := nil;
  _PEM_write_bio_PrivateKey := nil;
  _PEM_write_bio_PUBKEY := nil;

  // BIO

  _BIO_ctrl := nil;
  _BIO_s_file := nil;
  _BIO_new_file := nil;
  _BIO_new_mem_buf := nil;

  // Crypto Functions

  _SSLeay_version := nil;
end;

procedure locking_callback(mode, ltype: integer; lfile: PCharA; line: integer); cdecl;
begin
  if (mode and 1) > 0 then
    EnterCriticalSection(Locks[ltype])
  else
    LeaveCriticalSection(Locks[ltype]);
end;

procedure InitLocks;
var
  n: integer;
  max: integer;
begin
  max := _CRYPTOnumlocks;
  SetLength(Locks, max);
  for n := 0 to max - 1 do
    InitializeCriticalSection(Locks[n]);
  _CRYPTOSetLockingCallback(@locking_callback);
end;

procedure FreeLocks;
var
  n: integer;
begin
  _CRYPTOSetLockingCallback(nil);
  for n := 0 to length(Locks) - 1 do
    DeleteCriticalSection(Locks[n]);
  SetLength(Locks, 0);
end;

Procedure UnloadLibraries;

begin
  SSLloaded := false;
  if SSLLibHandle <> 0 then
  begin
    FreeLibrary(SSLLibHandle);
    SSLLibHandle := 0;
  end;
  if SSLUtilHandle <> 0 then
  begin
    FreeLibrary(SSLUtilHandle);
    SSLUtilHandle := 0;
  end;
end;

Function LoadLibraries: Boolean;
var
  SoftPath: string;
  I: integer;
begin
  Result := false;
  if LoadUtilLibrary then
  begin
    for I := Low(DLLSSLNames) to High(DLLSSLNames) do
    begin
      SSLLibHandle := LoadLib(SoftPath + DLLSSLNames[I]);
      Result := (SSLLibHandle <> 0) and (SSLUtilHandle <> 0);
      if Result then
        Break;
    end;
  end;
end;

function InitSSLInterface: Boolean;
begin
  Result := SSLloaded;
  if Result then
    exit;
  EnterCriticalSection(SSLCS);
  try
    if SSLloaded then
      exit;
    Result := LoadLibraries;
    if Not Result then
    begin
      UnloadLibraries;
      exit;
    end;
    LoadSSLEntryPoints;
    LoadUtilEntryPoints;
    // init library
    if Assigned(_SslLibraryInit) then
      _SslLibraryInit;
    if Assigned(_SslLoadErrorStrings) then
      _SslLoadErrorStrings;
    if Assigned(_OPENSSLaddallalgorithms) then
      _OPENSSLaddallalgorithms;
    if Assigned(_RandScreen) then
      _RandScreen;
    if Assigned(_CRYPTOnumlocks) and Assigned(_CRYPTOSetLockingCallback) then
      InitLocks;
    SSLloaded := True;
{$IFDEF OS2}
    Result := InitEMXHandles;
{$ELSE OS2}
    Result := True;
{$ENDIF OS2}
  finally
    LeaveCriticalSection(SSLCS);
  end;
end;

function DestroySSLInterface: Boolean;
begin
  Result := Not IsSSLloaded;
  if Result then
    exit;
  EnterCriticalSection(SSLCS);
  try
    if Assigned(_CRYPTOnumlocks) and Assigned(_CRYPTOSetLockingCallback) then
      FreeLocks;
    EVPcleanup;
    CRYPTOcleanupAllExData;
    ErrRemoveState(0);
    ClearUtilEntryPoints;
    ClearSSLEntryPoints;
    UnloadLibraries;
    Result := True;
  finally
    LeaveCriticalSection(SSLCS);
  end;
end;

initialization

InitializeCriticalSection(SSLCS);

finalization

DestroySSLInterface;
DeleteCriticalSection(SSLCS);

end.
