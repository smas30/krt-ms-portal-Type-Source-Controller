@actualizarTypeSourceFeat
Feature: Actualizar type source mediante PUT /api/v1/portal/ref-type-sources/{id}

  Background:
    * configure logPrettyResponse = false
    * configure logPrettyRequest = false
    * def validBodyRequest = read('classpath:JsonRequest/loginTokenRequest.json')
    * def loginResponse = call read('classpath:api/loginToken.feature') { request: validBodyRequest }
    * def authToken = loginResponse.response.token
    * def headers = headersTypeSourceConToken(authToken)
    * configure headers = headers
    * def schemaUtil = Java.type('util.JsonSchemaUtil')
    * def schemaText = karate.readAsString('classpath:Schema/sc_typeSourceUnico.json')

  @ActualizarTypeSource
  Scenario: Crear y luego actualizar un type source con datos únicos desde archivo
    * def crearRequest = read('classpath:JsonRequest/crearTypeSourceRequest.json')
    * def timestamp = java.lang.System.currentTimeMillis()
    * set crearRequest.label = crearRequest.label + ' ' + timestamp
    * set crearRequest.name = crearRequest.name + ' ' + timestamp
    Given url baseUrl
    And request crearRequest
    When method POST
    Then status 200
    * def typeSourceId = response.data.id
    And print 'Type Source creado con ID:', typeSourceId
    * def actualizarRequest = read('classpath:JsonRequest/actualizarTypeSourceRequest.json')
    Given url baseUrl + '/' + typeSourceId
    And request actualizarRequest
    When method PUT
    Then status 200
    And match response.data.id == typeSourceId
    And print 'Type Source actualizado exitosamente:', response.data

