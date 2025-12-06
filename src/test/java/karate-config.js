function fn() {
    var env = karate.env || 'dev';
    var baseUrl = '';
    var loginUrl = 'https://ms-auth-oss-dev-front-oss.apps.tmve-nprod-1.tmve-qa.com/intraLogin';

    // Configurar SSL para aceptar certificados autofirmados
    karate.configure('ssl', true);

    if (env === 'dev') {
        baseUrl = 'https://portal-inventario-bff-git-dev-front-oss.apps.tmve-nprod-1.tmve-qa.com/api/v1/portal/ref-type-sources';
    } else if (env === 'e2e') {
        baseUrl = 'https://examples.com/api/v1/portal/ref-type-sources';
    }

    // Headers para Type Source Controller
    var headersTypeSourceConToken = function(authToken) {
        return {
            'Content-Type': 'application/json',
            'X-CORRELATION-ID': '1445|E11011|234234',
            'X-TOKEN-ID': authToken
        };
    };

    return {
        env: env,
        baseUrl: baseUrl,
        loginUrl: loginUrl,
        headersTypeSourceConToken: headersTypeSourceConToken,
        readTimeout: 30000,
        connectTimeout: 10000
    };
}
