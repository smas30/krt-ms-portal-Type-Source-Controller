@obtenerTypeSources
Feature: Obtener type sources mediante el endpoint GET /api/v1/portal/ref-type-sources

  Background:
    # 1. LLAMANDO AL SERVICIO AUTHTOKEN PARA HACER LOGIN Y OBTENER EL TOKEN
    * configure logPrettyResponse = false
    * configure logPrettyRequest = false
    * def loginBody = read('classpath:JsonRequest/loginTokenRequest.json')
    * def loginResponse = call read('classpath:api/loginToken.feature') { request: loginBody }
    * def authToken = loginResponse.response.token

    # 2. CONFIGURANDO HEADERS PARA TYPE SOURCES
    * def headers = headersTypeSourceConToken(authToken)
    * configure headers = headers
    * print 'HEADERS usados en obtener type sources:', headers
    * print 'TOKEN obtenido:', authToken

    # 3. CONFIGURANDO VALIDACION DE SCHEMA
    * def schemaUtil = Java.type('util.JsonSchemaUtil')
    * def schemaText = karate.readAsString('classpath:Schema/sc_obtenerTypeSources.json')

  @obtenerTodosLosTypeSources
  Scenario: Obtener todos los type sources sin filtros
    Given url baseUrl
    And param limit = 1000
    And param page = 1
    When method GET
    Then status 200
    And match response.success == true
    And match response.data.data == '#array'
    * def responseText = karate.pretty(response)
    * def isValid = schemaUtil.isValid(schemaText, responseText)
    * match isValid == true
    And print 'Total de type sources encontrados:', response.data.data.length
    And print response
    And print '=== TIEMPO DE RESPUESTA DEL FEATURE ===', responseTime / 1000, 's'

  @paginacionTypeSources
  Scenario: Validar paginacion usando limit y page en GET de type sources
    # Pagina 1
    Given url baseUrl
    And param limit = 10
    And param page = 1
    When method GET
    Then status 200
    And match response.success == true
    * def paginaUno = response.data.data
    * print 'Pagina 1:', karate.pretty(paginaUno)

    # Pagina 2
    Given url baseUrl
    And param limit = 10
    And param page = 2
    When method GET
    Then status 200
    And match response.success == true
    * def paginaDos = response.data.data
    * print 'Pagina 2:', karate.pretty(paginaDos)
    And match response.data.page == 2
    * def responseText = karate.pretty(response)
    * def isValid = schemaUtil.isValid(schemaText, responseText)
    * match isValid == true
    And print '=== TIEMPO DE RESPUESTA DEL FEATURE ===', responseTime / 1000, 's'

