# Abstract class for defining an interface between a server and ActiveResource
# TODO: Ensure contentType is consistent in requests/responses
ActiveResource.Interfaces = class ActiveResource::Interfaces
  class @::Base
    @contentType = 'application/json'

    constructor: (@resourceLibrary) ->
      @axios = axios.create(
        headers: _.extend(@resourceLibrary.headers || {}, {
          'Content-Type': @constructor.contentType
        })
      )

      @axios.interceptors.response.use(
        (config) => config,
        (error) =>
          if (error.response.status == 408 || error.code == 'ECONNABORTED')
            Promise.reject(
              response:
                data:
                  errors: [
                    {
                      code: 'timeout',
                      detail: "Timeout occurred while loading #{error.config.url}"
                    }
                  ]
            )
          else
            Promise.reject(error)
      );

    # Makes an HTTP request to a url with data
    #
    # @param [String] url the url to query
    # @param [String] method the HTTP verb to use for the request
    # @param [Object] data the data to send to the server
    request: (url, method, data) ->
      options =
        responseType: 'json'
        method: method
        url: url

      if method == 'GET'
        options.params = data
        options.paramsSerializer = (params) ->
          Qs.stringify(params, { arrayFormat: 'brackets' })
      else
        options.data = data

      @axios.request options

    # Make GET request
    #
    # @param [String] url the url to query
    # @param [Object] queryParams query params to send to the server
    get: (url, queryParams) ->
      throw '#get not implemented on base interface'

    # Make POST request
    #
    # @param [String] url the url to query
    # @param [Object] resourceData the resourceData to send to the server
    # @param [Object] options options that may modify the data sent to the server
    post: (url, resourceData, options) ->
      throw '#post not implemented on base interface'

    # Make PATCH request
    #
    # @param [String] url the url to query
    # @param [Object] resourceData the resourceData to send to the server
    # @param [Object] options options that may modify the data sent to the server
    patch: (url, resourceData, options) ->
      throw '#patch not implemented on base interface'

    # Make PUT request
    #
    # @param [String] url the url to query
    # @param [Object] resourceData the resourceData to send to the server
    # @param [Object] options options that may modify the data sent to the server
    put: (url, resourceData, options) ->
      throw '#put not implemented on base interface'

    # Make DELETE request
    #
    # @param [String] url the url to query
    # @param [Object] resourceData the resourceData to send to the server
    # @param [Object] options options that may modify the data sent to the server
    delete: (url, resourceData, options) ->
      throw '#delete not implemented on base interface'
