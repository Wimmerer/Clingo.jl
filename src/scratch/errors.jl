macro wraperror(code)
    quote
    if !$(esc(code))
        message = unsafe_string(LibClingo.clingo_error_message())
        code = LibClingo.clingo_error_e(LibClingo.clingo_error_code())
        error("$code: $message")
    end
end
end