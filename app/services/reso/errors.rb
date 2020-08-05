module Reso
	class Errors
		def self.error_message(error_name: nil)
			if e = Reso::Errors.error_info(error_name: error_name) and message = e[:text]
				return message
			end
		end

		def self.error_code(error_name: nil)
			if e = Reso::Errors.error_info(error_name: error_name) and code = e[:code]
				return code
			end
		end

		def self.error_info(error_name: nil)
			RESO_COMMON_ERRORS[error_name]
		end

		RESO_COMMON_ERRORS = {
				# RETS errors. Should be removed/changed
				:OperationSuccessful => {
						:code => 0,
						:text => 'Operation successful',
						:description => ''
				},
				:ZeroBalance => {
						:code => 20003,
						:text => "Zero Balance",
						:description => "The user has zero balance left in their account"
				},
				:BrokerCodeRequired => {
						:code => 20012,
						:text => "Broker Code Required",
						:description => "The user belongs to multiple broker codes and one must be supplied as part of the login. The broker list is sent back to the client as part of the login response (see section 4.6)."
				},
				:BrokerCodeInvalid => {
						:code => 20013,
						:text => "Broker Code Invalid",
						:description => "The Broker Code sent by the client is not valid or not valid for the user"
				},
				:AdditionalLoginNotPermitted => {
						:code => 20022,
						:text => "Additional login not permitted",
						:description => "There is already a user logged in with this user name, and this server does not permit multiple logins."
				},
				:MiscellaneousServerLoginError => {
						:code => 20036,
						:text => "Miscellaneous server login error",
						:description => "The quoted-string of the body-start-line contains text that SHOULD be displayed to the user"
				},
				:ServerTemporarilyDisabled => {
						:code => 20050,
						:text => "Server Temporarily Disabled",
						:description => "The server is temporarily offline. The user should try again later"
				},
				:GetObjectInvalidResource => {
						:code => 20400,
						:text => "Invalid Resource",
						:description => "The request could not be understood due to an unknown resource."
				},
				:GetObjectInvalidType => {
						:code => 20401,
						:text => "Invalid Type",
						:description => "The request could not be understood due to an unknown object type for the resource."
				},
				:GetObjectInvalidIdentifier => {
						:code => 20402,
						:text => "Invalid Identifier",
						:description => "The identifier does not match the KeyField of any data in the resource."
				},
				:NoObjectFound => {
						:code => 20403,
						:text => "No Object Found",
						:description => "No matching object was found to satisfy the request."
				},
				:UnsupportedMimeType => {
						:code => 20406,
						:text => "Unsupported MIME type",
						:description => "The server cannot return the object in any of the requested MIME types."
				},
				:GetObjectUnauthorizedRetrieval => {
						:code => 20407,
						:text => "Unauthorized Retrieval",
						:description => "The object could not be retrieved because it requests an object to which the supplied login does not grant access."
				},
				:GetObjectResourceUnavailable => {
						:code => 20408,
						:text => "Resource Unavailable",
						:description => "The requested resource is currently unavailable."
				},
				:ObjectUnavailable => {
						:code => 20409,
						:text => "Object Unavailable",
						:description => "The requested object is currently unavailable."
				},
				:GetObjectRequestTooLarge => {
						:code => 20410,
						:text => "Request Too Large",
						:description => "No further objects will be retrieved because a system limit was exceeded."
				},
				:GetObjectTimeout => {
						:code => 20411,
						:text => "Timeout",
						:description => "The request timed out while executing"
				},
				:GetObjectTooManyOutstandingRequests => {
						:code => 20412,
						:text => "Too many outstanding requests",
						:description => "The user has too many outstanding requests and new requests will not be accepted at this time."
				},
				:MiscellaneousGetObjectError => {
						:code => 20413,
						:text => "Miscellaneous error",
						:description => "The server encountered an internal error."
				},
				:NotLoggedIn => {
						:code => 20701,
						:text => "Not logged in",
						:description => "The server did not detect an active login for the session in which the Logout transaction was submitted."
				},
				:MiscellaneousLogoutError => {
						:code => 20702,
						:text => "Miscellaneous error",
						:description => "The transaction could not be completed. The ReplyText gives additional information."
				},
				:UnknownQueryField => {
						:code => 20200,
						:text => "Unknown Query Field",
						:description => "The query could not be understood due to an unknown field name."
				},
				:NoRecordsFound => {
						:code => 20201,
						:text => "No Records Found",
						:description => "No matching records were found."
				},
				:InvalidQuerySyntax => {
						:code => 20206,
						:text => "Invalid Query Syntax",
						:description => "The query could not be understood due to a syntax error."
				},
				:UnauthorizedQuery => {
						:code => 20207,
						:text => "Unauthorized Query",
						:description => "The query could not be executed because it refers to a field to which the supplied login does not grant access."
				},
				:MaximumRecordsExceeded => {
						:code => 20208,
						:text => "Maximum Records Exceeded",
						:description => "Operation successful, but all of the records have not been returned. This reply code indicates that the maximum records allowed to be returned by the server have been exceeded. Note: reaching/exceeding the Limit value in the client request is not a cause for the server to generate this error."
				},
				:SearchTimeout => {
						:code => 20209,
						:text => "Timeout",
						:description => "The request timed out while executing"
				},
				:TooManyOutstandingQueries => {
						:code => 20210,
						:text => "Too many outstanding queries",
						:description => "The user has too many outstanding queries and new queries will not be accepted at this time."
				},
				:QueryTooComplex => {
						:code => 20211,
						:text => "Query too complex",
						:description => "The query is too complex to be processed. For example, the query contains too many nesting levels or too many values for a lookup field."
				},
				:InvalidKeyRequest => {
						:code => 20212,
						:text => "Invalid key request",
						:description => "The transaction does not meet the server's requirements for the use of the Key option."
				},
				:InvalidKey => {
						:code => 20213,
						:text => "Invalid Key",
						:description => "The transaction uses a key that is incorrect or is no longer valid. Servers are not required to detect all possible invalid key values."
				},
				:InsecurePassword => {
						:code => 20140,
						:text => "Insecure password",
						:description => "The password does not meet the site's rules for password security."
				},
				:SameAsPreviousPassword => {
						:code => 20141,
						:text => "Same as Previous Password",
						:description => "The new password is the same as the old one."
				},
				:TheEncryptedUserNameWasInvalid => {
						:code => 20142,
						:text => "The encrypted user name was invalid",
						:description => ""
				},
				:UnableToSaveRecordOnServer => {
						:code => 20302,
						:text => "Unable to save record on server",
						:description => ""
				},
				:MiscellaneousUpdateError => {
						:code => 20303,
						:text => "Miscellaneous Update Error",
						:description => ""
				},
				:WarningResponseWasNotGivenForAllWarningsThatContainedAResponseRequiredValueOf2 => {
						:code => 20311,
						:text => "WarningResponse was not given for all warnings that contained a response-required value of 2",
						:description => ""
				},
				:WarningResponseWasGivenForAWarningThatContainedAResponseRequiredValueOf0 => {
						:code => 20312,
						:text => "WarningResponse was given for a warning that contained a response-required value of 0",
						:description => ""
				},
				:GetMetadataInvalidResource => {
						:code => 20500,
						:text => "Invalid Resource",
						:description => "The request could not be understood due to an unknown resource."
				},
				:GetMetadataInvalidType => {
						:code => 20501,
						:text => "Invalid Type",
						:description => "The request could not be understood due to an unknown metadata type."
				},
				:GetMetadataInvalidIdentifier => {
						:code => 20502,
						:text => "Invalid Identifier",
						:description => "The identifier is not known inside the specified resource."
				},
				:NoMetadataFound => {
						:code => 20503,
						:text => "No Metadata Found",
						:description => "No matching metadata of the type requested was found."
				},
				:UnsupportedMimetype => {
						:code => 20506,
						:text => "Unsupported Mimetype",
						:description => "The server cannot return the metadata in any of the requested MIME types."
				},
				:GetMetadataUnauthorizedRetrieval => {
						:code => 20507,
						:text => "Unauthorized Retrieval",
						:description => "The metadata could not be retrieved because it requests metadata to which the supplied login does not grant access (e.g. Update Type data)."
				},
				:GetMetadataResourceUnavailable => {
						:code => 20508,
						:text => "Resource Unavailable",
						:description => "The requested resource is currently unavailable."
				},
				:MetadataUnavailable => {
						:code => 20509,
						:text => "Metadata Unavailable",
						:description => "The requested metadata is currently unavailable."
				},
				:GetMetadataRequestTooLarge => {
						:code => 20510,
						:text => "Request Too Large",
						:description => "Metadata could not be retrieved because a system limit was exceeded."
				},
				:GetMetadataTimeout => {
						:code => 20511,
						:text => "Timeout",
						:description => "The request timed out while executing."
				},
				:GetMetadataTooManyOutstandingRequests => {
						:code => 20512,
						:text => "Too many outstanding requests",
						:description => "The user has too many outstanding requests and new requests will not be accepted at this time."
				},
				:MiscellaneousGetMetadataError => {
						:code => 20513,
						:text => "Miscellaneous error",
						:description => "The server encountered an internal error."
				},
				:SearchRequestedDTDVersionUnavailable => {
						:code => 20514,
						:text => "Requested DTD version unavailable",
						:description => "The client has requested the metadata in STANDARD-XML format using a DTD version that the server cannot provide."
				},
				:GetMetadataRequestedDTDVersionUnavailable => {
						:code => 20514,
						:text => "Requested DTD version unavailable",
						:description => "The client has requested the metadata in STANDARD-XML format using a DTD version that the server cannot provide."
				},

				# RESO Error codes
				:InvalidParameter => {
						:code => 400,
						:text => "Invalid parameter",
						:description => "Additional information is provided in the error block."
				},
				:MiscellaneousSearchError => {
						:code => 400,
						:text => "Miscellaneous Search Error",
						:description => "Miscellaneous Search Error."
				},
				:CannotFindProperty => {
						:code => 400,
						:text => "Cannot find property",
						:description => "The Filter statement contains field names that are not recognized by the server."
				},
				:InvalidSelect => {
						:code => 400,
						:text => "Invalid Select",
						:description => "The Select statement contains field names that are not recognized by the server."
				},
				:InvalidValueType => {
						:code => 400,
						:text => "Invalid Value Type",
						:description => "The request could not be understood due to an unknown object type for the value."
				},
		}
	end
end