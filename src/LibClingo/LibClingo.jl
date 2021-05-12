module LibClingo
using Clingo_jll: libclingo
using MacroTools
export Control, Model, Handle, Configuration

macro wraperror(code)
    MacroTools.@q begin
        if !$(esc(code))
            message = unsafe_string(clingo_error_message())
            code = clingo_error_e(clingo_error_code())
            error("$code: $message")
        end
    end
end

const literal_t = Int32

const atom_t = UInt32

const id_t = UInt32

const weight_t = Int32

struct weighted_literal_t
    literal::literal_t
    weight::weight_t
end

@enum error_e::UInt32 begin
    error_success = 0
    error_runtime = 1
    error_logic = 2
    error_bad_alloc = 3
    error_unknown = 4
end

const error_t = Cint

function error_string(code)
    ccall((:clingo_error_string, libclingo), Cstring, (error_t,), code)
end

# no prototype is found for this function at clingo.h:155:42, please use with caution
function error_code()
    ccall((:clingo_error_code, libclingo), error_t, ())
end

# no prototype is found for this function at clingo.h:159:39, please use with caution
function error_message()
    ccall((:clingo_error_message, libclingo), Cstring, ())
end

function set_error(code, message)
    ccall((:clingo_set_error, libclingo), Cvoid, (error_t, Cstring), code, message)
end

@enum warning_e::UInt32 begin
    warning_operation_undefined = 0
    warning_runtime_error = 1
    warning_atom_undefined = 2
    warning_file_included = 3
    warning_variable_unbounded = 4
    warning_global_variable = 5
    warning_other = 6
end

const warning_t = Cint

function warning_string(code)
    ccall((:clingo_warning_string, libclingo), Cstring, (warning_t,), code)
end

# typedef void ( * logger_t ) ( warning_t code , char const * message , void * data )
const logger_t = Ptr{Cvoid}

function version()
    major = Ref{Cint}(0)
    minor = Ref{Cint}(0)
    revision = Ref{Cint}(0)
    ccall((:clingo_version, libclingo), Cvoid, (Ptr{Cint}, Ptr{Cint}, Ptr{Cint}), major, minor, revision)
    return (major[], minor[], revision[])
end

@enum truth_value_e::UInt32 begin
    truth_value_free = 0
    truth_value_true = 1
    truth_value_false = 2
end

const truth_value_t = Cint

struct location_t
    begin_file::Cstring
    end_file::Cstring
    begin_line::Csize_t
    end_line::Csize_t
    begin_column::Csize_t
    end_column::Csize_t
end

const signature_t = UInt64

function signature_create(name, arity, positive, signature)
    @wraperror ccall((:clingo_signature_create, libclingo), Bool, (Cstring, UInt32, Bool, Ptr{signature_t}), name, arity, positive, signature)
end

function signature_name(signature)
    ccall((:clingo_signature_name, libclingo), Cstring, (signature_t,), signature)
end

function signature_arity(signature)
    ccall((:clingo_signature_arity, libclingo), UInt32, (signature_t,), signature)
end

function signature_is_positive(signature)
    @wraperror ccall((:clingo_signature_is_positive, libclingo), Bool, (signature_t,), signature)
end

function signature_is_negative(signature)
    @wraperror ccall((:clingo_signature_is_negative, libclingo), Bool, (signature_t,), signature)
end

function signature_is_equal_to(a, b)
    @wraperror ccall((:clingo_signature_is_equal_to, libclingo), Bool, (signature_t, signature_t), a, b)
end

function signature_is_less_than(a, b)
    @wraperror ccall((:clingo_signature_is_less_than, libclingo), Bool, (signature_t, signature_t), a, b)
end

function signature_hash(signature)
    ccall((:clingo_signature_hash, libclingo), Csize_t, (signature_t,), signature)
end

@enum symbol_type_e::UInt32 begin
    symbol_type_infimum = 0
    symbol_type_number = 1
    symbol_type_string = 4
    symbol_type_function = 5
    symbol_type_supremum = 7
end

const symbol_type_t = Cint

const symbol_t = UInt64

function symbol_create_number(number, symbol)
    ccall((:clingo_symbol_create_number, libclingo), Cvoid, (Cint, Ptr{symbol_t}), number, symbol)
end

function symbol_create_supremum(symbol)
    ccall((:clingo_symbol_create_supremum, libclingo), Cvoid, (Ptr{symbol_t},), symbol)
end

function symbol_create_infimum(symbol)
    ccall((:clingo_symbol_create_infimum, libclingo), Cvoid, (Ptr{symbol_t},), symbol)
end

function symbol_create_string(string, symbol)
    @wraperror ccall((:clingo_symbol_create_string, libclingo), Bool, (Cstring, Ptr{symbol_t}), string, symbol)
end

function symbol_create_id(name, positive, symbol)
    @wraperror ccall((:clingo_symbol_create_id, libclingo), Bool, (Cstring, Bool, Ptr{symbol_t}), name, positive, symbol)
end

function symbol_create_function(name, arguments, arguments_size, positive, symbol)
    @wraperror ccall((:clingo_symbol_create_function, libclingo), Bool, (Cstring, Ptr{symbol_t}, Csize_t, Bool, Ptr{symbol_t}), name, arguments, arguments_size, positive, symbol)
end

function symbol_number(symbol, number)
    @wraperror ccall((:clingo_symbol_number, libclingo), Bool, (symbol_t, Ptr{Cint}), symbol, number)
end

function symbol_name(symbol, name)
    @wraperror ccall((:clingo_symbol_name, libclingo), Bool, (symbol_t, Ptr{Ptr{Cchar}}), symbol, name)
end

function symbol_string(symbol, string)
    @wraperror ccall((:clingo_symbol_string, libclingo), Bool, (symbol_t, Ptr{Ptr{Cchar}}), symbol, string)
end

function symbol_is_positive(symbol, positive)
    @wraperror ccall((:clingo_symbol_is_positive, libclingo), Bool, (symbol_t, Ptr{Bool}), symbol, positive)
end

function symbol_is_negative(symbol, negative)
    @wraperror ccall((:clingo_symbol_is_negative, libclingo), Bool, (symbol_t, Ptr{Bool}), symbol, negative)
end

function symbol_arguments(symbol, arguments, arguments_size)
    @wraperror ccall((:clingo_symbol_arguments, libclingo), Bool, (symbol_t, Ptr{Ptr{symbol_t}}, Ptr{Csize_t}), symbol, arguments, arguments_size)
end

function symbol_type(symbol)
    ccall((:clingo_symbol_type, libclingo), symbol_type_t, (symbol_t,), symbol)
end

function symbol_to_string_size(symbol, size)
    @wraperror ccall((:clingo_symbol_to_string_size, libclingo), Bool, (symbol_t, Ptr{Csize_t}), symbol, size)
end

function symbol_to_string(symbol, string, size)
    @wraperror ccall((:clingo_symbol_to_string, libclingo), Bool, (symbol_t, Cstring, Csize_t), symbol, string, size)
end

function symbol_is_equal_to(a, b)
    @wraperror ccall((:clingo_symbol_is_equal_to, libclingo), Bool, (symbol_t, symbol_t), a, b)
end

function symbol_is_less_than(a, b)
    @wraperror ccall((:clingo_symbol_is_less_than, libclingo), Bool, (symbol_t, symbol_t), a, b)
end

function symbol_hash(symbol)
    ccall((:clingo_symbol_hash, libclingo), Csize_t, (symbol_t,), symbol)
end

function add_string(string, result)
    @wraperror ccall((:clingo_add_string, libclingo), Bool, (Cstring, Ptr{Ptr{Cchar}}), string, result)
end

function parse_term(string, logger, logger_data, message_limit, symbol)
    @wraperror ccall((:clingo_parse_term, libclingo), Bool, (Cstring, logger_t, Ptr{Cvoid}, Cuint, Ptr{symbol_t}), string, logger, logger_data, message_limit, symbol)
end

mutable struct symbolic_atoms_t end

const symbolic_atom_iterator_t = UInt64

function symbolic_atoms_size(atoms, size)
    @wraperror ccall((:clingo_symbolic_atoms_size, libclingo), Bool, (Ptr{symbolic_atoms_t}, Ptr{Csize_t}), atoms, size)
end

function symbolic_atoms_begin(atoms, signature, iterator)
    @wraperror ccall((:clingo_symbolic_atoms_begin, libclingo), Bool, (Ptr{symbolic_atoms_t}, Ptr{signature_t}, Ptr{symbolic_atom_iterator_t}), atoms, signature, iterator)
end

function symbolic_atoms_end(atoms, iterator)
    @wraperror ccall((:clingo_symbolic_atoms_end, libclingo), Bool, (Ptr{symbolic_atoms_t}, Ptr{symbolic_atom_iterator_t}), atoms, iterator)
end

function symbolic_atoms_find(atoms, symbol, iterator)
    @wraperror ccall((:clingo_symbolic_atoms_find, libclingo), Bool, (Ptr{symbolic_atoms_t}, symbol_t, Ptr{symbolic_atom_iterator_t}), atoms, symbol, iterator)
end

function symbolic_atoms_iterator_is_equal_to(atoms, a, b, equal)
    @wraperror ccall((:clingo_symbolic_atoms_iterator_is_equal_to, libclingo), Bool, (Ptr{symbolic_atoms_t}, symbolic_atom_iterator_t, symbolic_atom_iterator_t, Ptr{Bool}), atoms, a, b, equal)
end

function symbolic_atoms_symbol(atoms, iterator, symbol)
    @wraperror ccall((:clingo_symbolic_atoms_symbol, libclingo), Bool, (Ptr{symbolic_atoms_t}, symbolic_atom_iterator_t, Ptr{symbol_t}), atoms, iterator, symbol)
end

function symbolic_atoms_is_fact(atoms, iterator, fact)
    @wraperror ccall((:clingo_symbolic_atoms_is_fact, libclingo), Bool, (Ptr{symbolic_atoms_t}, symbolic_atom_iterator_t, Ptr{Bool}), atoms, iterator, fact)
end

function symbolic_atoms_is_external(atoms, iterator, external)
    @wraperror ccall((:clingo_symbolic_atoms_is_external, libclingo), Bool, (Ptr{symbolic_atoms_t}, symbolic_atom_iterator_t, Ptr{Bool}), atoms, iterator, external)
end

function symbolic_atoms_literal(atoms, iterator, literal)
    @wraperror ccall((:clingo_symbolic_atoms_literal, libclingo), Bool, (Ptr{symbolic_atoms_t}, symbolic_atom_iterator_t, Ptr{literal_t}), atoms, iterator, literal)
end

function symbolic_atoms_signatures_size(atoms, size)
    @wraperror ccall((:clingo_symbolic_atoms_signatures_size, libclingo), Bool, (Ptr{symbolic_atoms_t}, Ptr{Csize_t}), atoms, size)
end

function symbolic_atoms_signatures(atoms, signatures, size)
    @wraperror ccall((:clingo_symbolic_atoms_signatures, libclingo), Bool, (Ptr{symbolic_atoms_t}, Ptr{signature_t}, Csize_t), atoms, signatures, size)
end

function symbolic_atoms_next(atoms, iterator, next)
    @wraperror ccall((:clingo_symbolic_atoms_next, libclingo), Bool, (Ptr{symbolic_atoms_t}, symbolic_atom_iterator_t, Ptr{symbolic_atom_iterator_t}), atoms, iterator, next)
end

function symbolic_atoms_is_valid(atoms, iterator, valid)
    @wraperror ccall((:clingo_symbolic_atoms_is_valid, libclingo), Bool, (Ptr{symbolic_atoms_t}, symbolic_atom_iterator_t, Ptr{Bool}), atoms, iterator, valid)
end

# typedef bool ( * clingo_symbol_callback_t ) ( clingo_symbol_t const * symbols , size_t symbols_size , void * data )
const symbol_callback_t = Ptr{Cvoid}

@enum theory_term_type_e::UInt32 begin
    theory_term_type_tuple = 0
    theory_term_type_list = 1
    theory_term_type_set = 2
    theory_term_type_function = 3
    theory_term_type_number = 4
    theory_term_type_symbol = 5
end

const theory_term_type_t = Cint

mutable struct theory_atoms_t end

function theory_atoms_term_type(atoms, term, type)
    @wraperror ccall((:clingo_theory_atoms_term_type, libclingo), Bool, (Ptr{theory_atoms_t}, id_t, Ptr{theory_term_type_t}), atoms, term, type)
end

function theory_atoms_term_number(atoms, term, number)
    @wraperror ccall((:clingo_theory_atoms_term_number, libclingo), Bool, (Ptr{theory_atoms_t}, id_t, Ptr{Cint}), atoms, term, number)
end

function theory_atoms_term_name(atoms, term, name)
    @wraperror ccall((:clingo_theory_atoms_term_name, libclingo), Bool, (Ptr{theory_atoms_t}, id_t, Ptr{Ptr{Cchar}}), atoms, term, name)
end

function theory_atoms_term_arguments(atoms, term, arguments, size)
    @wraperror ccall((:clingo_theory_atoms_term_arguments, libclingo), Bool, (Ptr{theory_atoms_t}, id_t, Ptr{Ptr{id_t}}, Ptr{Csize_t}), atoms, term, arguments, size)
end

function theory_atoms_term_to_string_size(atoms, term, size)
    @wraperror ccall((:clingo_theory_atoms_term_to_string_size, libclingo), Bool, (Ptr{theory_atoms_t}, id_t, Ptr{Csize_t}), atoms, term, size)
end

function theory_atoms_term_to_string(atoms, term, string, size)
    @wraperror ccall((:clingo_theory_atoms_term_to_string, libclingo), Bool, (Ptr{theory_atoms_t}, id_t, Cstring, Csize_t), atoms, term, string, size)
end

function theory_atoms_element_tuple(atoms, element, tuple, size)
    @wraperror ccall((:clingo_theory_atoms_element_tuple, libclingo), Bool, (Ptr{theory_atoms_t}, id_t, Ptr{Ptr{id_t}}, Ptr{Csize_t}), atoms, element, tuple, size)
end

function theory_atoms_element_condition(atoms, element, condition, size)
    @wraperror ccall((:clingo_theory_atoms_element_condition, libclingo), Bool, (Ptr{theory_atoms_t}, id_t, Ptr{Ptr{literal_t}}, Ptr{Csize_t}), atoms, element, condition, size)
end

function theory_atoms_element_condition_id(atoms, element, condition)
    @wraperror ccall((:clingo_theory_atoms_element_condition_id, libclingo), Bool, (Ptr{theory_atoms_t}, id_t, Ptr{literal_t}), atoms, element, condition)
end

function theory_atoms_element_to_string_size(atoms, element, size)
    @wraperror ccall((:clingo_theory_atoms_element_to_string_size, libclingo), Bool, (Ptr{theory_atoms_t}, id_t, Ptr{Csize_t}), atoms, element, size)
end

function theory_atoms_element_to_string(atoms, element, string, size)
    @wraperror ccall((:clingo_theory_atoms_element_to_string, libclingo), Bool, (Ptr{theory_atoms_t}, id_t, Cstring, Csize_t), atoms, element, string, size)
end

function theory_atoms_size(atoms, size)
    @wraperror ccall((:clingo_theory_atoms_size, libclingo), Bool, (Ptr{theory_atoms_t}, Ptr{Csize_t}), atoms, size)
end

function theory_atoms_atom_term(atoms, atom, term)
    @wraperror ccall((:clingo_theory_atoms_atom_term, libclingo), Bool, (Ptr{theory_atoms_t}, id_t, Ptr{id_t}), atoms, atom, term)
end

function theory_atoms_atom_elements(atoms, atom, elements, size)
    @wraperror ccall((:clingo_theory_atoms_atom_elements, libclingo), Bool, (Ptr{theory_atoms_t}, id_t, Ptr{Ptr{id_t}}, Ptr{Csize_t}), atoms, atom, elements, size)
end

function theory_atoms_atom_has_guard(atoms, atom, has_guard)
    @wraperror ccall((:clingo_theory_atoms_atom_has_guard, libclingo), Bool, (Ptr{theory_atoms_t}, id_t, Ptr{Bool}), atoms, atom, has_guard)
end

function theory_atoms_atom_guard(atoms, atom, connective, term)
    @wraperror ccall((:clingo_theory_atoms_atom_guard, libclingo), Bool, (Ptr{theory_atoms_t}, id_t, Ptr{Ptr{Cchar}}, Ptr{id_t}), atoms, atom, connective, term)
end

function theory_atoms_atom_literal(atoms, atom, literal)
    @wraperror ccall((:clingo_theory_atoms_atom_literal, libclingo), Bool, (Ptr{theory_atoms_t}, id_t, Ptr{literal_t}), atoms, atom, literal)
end

function theory_atoms_atom_to_string_size(atoms, atom, size)
    @wraperror ccall((:clingo_theory_atoms_atom_to_string_size, libclingo), Bool, (Ptr{theory_atoms_t}, id_t, Ptr{Csize_t}), atoms, atom, size)
end

function theory_atoms_atom_to_string(atoms, atom, string, size)
    @wraperror ccall((:clingo_theory_atoms_atom_to_string, libclingo), Bool, (Ptr{theory_atoms_t}, id_t, Cstring, Csize_t), atoms, atom, string, size)
end

mutable struct assignment_t end

function assignment_decision_level(assignment)
    ccall((:clingo_assignment_decision_level, libclingo), UInt32, (Ptr{assignment_t},), assignment)
end

function assignment_root_level(assignment)
    ccall((:clingo_assignment_root_level, libclingo), UInt32, (Ptr{assignment_t},), assignment)
end

function assignment_has_conflict(assignment)
    @wraperror ccall((:clingo_assignment_has_conflict, libclingo), Bool, (Ptr{assignment_t},), assignment)
end

function assignment_has_literal(assignment, literal)
    @wraperror ccall((:clingo_assignment_has_literal, libclingo), Bool, (Ptr{assignment_t}, literal_t), assignment, literal)
end

function assignment_level(assignment, literal, level)
    @wraperror ccall((:clingo_assignment_level, libclingo), Bool, (Ptr{assignment_t}, literal_t, Ptr{UInt32}), assignment, literal, level)
end

function assignment_decision(assignment, level, literal)
    @wraperror ccall((:clingo_assignment_decision, libclingo), Bool, (Ptr{assignment_t}, UInt32, Ptr{literal_t}), assignment, level, literal)
end

function assignment_is_fixed(assignment, literal, is_fixed)
    @wraperror ccall((:clingo_assignment_is_fixed, libclingo), Bool, (Ptr{assignment_t}, literal_t, Ptr{Bool}), assignment, literal, is_fixed)
end

function assignment_is_true(assignment, literal, is_true)
    @wraperror ccall((:clingo_assignment_is_true, libclingo), Bool, (Ptr{assignment_t}, literal_t, Ptr{Bool}), assignment, literal, is_true)
end

function assignment_is_false(assignment, literal, is_false)
    @wraperror ccall((:clingo_assignment_is_false, libclingo), Bool, (Ptr{assignment_t}, literal_t, Ptr{Bool}), assignment, literal, is_false)
end

function assignment_truth_value(assignment, literal, value)
    @wraperror ccall((:clingo_assignment_truth_value, libclingo), Bool, (Ptr{assignment_t}, literal_t, Ptr{truth_value_t}), assignment, literal, value)
end

function assignment_size(assignment)
    ccall((:clingo_assignment_size, libclingo), Csize_t, (Ptr{assignment_t},), assignment)
end

function assignment_at(assignment, offset, literal)
    @wraperror ccall((:clingo_assignment_at, libclingo), Bool, (Ptr{assignment_t}, Csize_t, Ptr{literal_t}), assignment, offset, literal)
end

function assignment_is_total(assignment)
    @wraperror ccall((:clingo_assignment_is_total, libclingo), Bool, (Ptr{assignment_t},), assignment)
end

function assignment_trail_size(assignment, size)
    @wraperror ccall((:clingo_assignment_trail_size, libclingo), Bool, (Ptr{assignment_t}, Ptr{UInt32}), assignment, size)
end

function assignment_trail_begin(assignment, level, offset)
    @wraperror ccall((:clingo_assignment_trail_begin, libclingo), Bool, (Ptr{assignment_t}, UInt32, Ptr{UInt32}), assignment, level, offset)
end

function assignment_trail_end(assignment, level, offset)
    @wraperror ccall((:clingo_assignment_trail_end, libclingo), Bool, (Ptr{assignment_t}, UInt32, Ptr{UInt32}), assignment, level, offset)
end

function assignment_trail_at(assignment, offset, literal)
    @wraperror ccall((:clingo_assignment_trail_at, libclingo), Bool, (Ptr{assignment_t}, UInt32, Ptr{literal_t}), assignment, offset, literal)
end

@enum propagator_check_mode_e::UInt32 begin
    propagator_check_mode_none = 0
    propagator_check_mode_total = 1
    propagator_check_mode_fixpoint = 2
    propagator_check_mode_both = 3
end

const propagator_check_mode_t = Cint

@enum weight_constraint_type_e::Int32 begin
    weight_constraint_type_implication_left = -1
    weight_constraint_type_implication_right = 1
    weight_constraint_type_equivalence = 0
end

const weight_constraint_type_t = Cint

mutable struct propagate_init_t end

function propagate_init_solver_literal(init, aspif_literal, solver_literal)
    @wraperror ccall((:clingo_propagate_init_solver_literal, libclingo), Bool, (Ptr{propagate_init_t}, literal_t, Ptr{literal_t}), init, aspif_literal, solver_literal)
end

function propagate_init_add_watch(init, solver_literal)
    @wraperror ccall((:clingo_propagate_init_add_watch, libclingo), Bool, (Ptr{propagate_init_t}, literal_t), init, solver_literal)
end

function propagate_init_add_watch_to_thread(init, solver_literal, thread_id)
    @wraperror ccall((:clingo_propagate_init_add_watch_to_thread, libclingo), Bool, (Ptr{propagate_init_t}, literal_t, id_t), init, solver_literal, thread_id)
end

function propagate_init_remove_watch(init, solver_literal)
    @wraperror ccall((:clingo_propagate_init_remove_watch, libclingo), Bool, (Ptr{propagate_init_t}, literal_t), init, solver_literal)
end

function propagate_init_remove_watch_from_thread(init, solver_literal, thread_id)
    @wraperror ccall((:clingo_propagate_init_remove_watch_from_thread, libclingo), Bool, (Ptr{propagate_init_t}, literal_t, UInt32), init, solver_literal, thread_id)
end

function propagate_init_freeze_literal(init, solver_literal)
    @wraperror ccall((:clingo_propagate_init_freeze_literal, libclingo), Bool, (Ptr{propagate_init_t}, literal_t), init, solver_literal)
end

function propagate_init_symbolic_atoms(init, atoms)
    @wraperror ccall((:clingo_propagate_init_symbolic_atoms, libclingo), Bool, (Ptr{propagate_init_t}, Ptr{Ptr{symbolic_atoms_t}}), init, atoms)
end

function propagate_init_theory_atoms(init, atoms)
    @wraperror ccall((:clingo_propagate_init_theory_atoms, libclingo), Bool, (Ptr{propagate_init_t}, Ptr{Ptr{theory_atoms_t}}), init, atoms)
end

function propagate_init_number_of_threads(init)
    ccall((:clingo_propagate_init_number_of_threads, libclingo), Cint, (Ptr{propagate_init_t},), init)
end

function propagate_init_set_check_mode(init, mode)
    ccall((:clingo_propagate_init_set_check_mode, libclingo), Cvoid, (Ptr{propagate_init_t}, propagator_check_mode_t), init, mode)
end

function propagate_init_get_check_mode(init)
    ccall((:clingo_propagate_init_get_check_mode, libclingo), propagator_check_mode_t, (Ptr{propagate_init_t},), init)
end

function propagate_init_assignment(init)
    ccall((:clingo_propagate_init_assignment, libclingo), Ptr{assignment_t}, (Ptr{propagate_init_t},), init)
end

function propagate_init_add_literal(init, freeze, result)
    @wraperror ccall((:clingo_propagate_init_add_literal, libclingo), Bool, (Ptr{propagate_init_t}, Bool, Ptr{literal_t}), init, freeze, result)
end

function propagate_init_add_clause(init, clause, size, result)
    @wraperror ccall((:clingo_propagate_init_add_clause, libclingo), Bool, (Ptr{propagate_init_t}, Ptr{literal_t}, Csize_t, Ptr{Bool}), init, clause, size, result)
end

function propagate_init_add_weight_constraint(init, literal, literals, size, bound, type, compare_equal, result)
    @wraperror ccall((:clingo_propagate_init_add_weight_constraint, libclingo), Bool, (Ptr{propagate_init_t}, literal_t, Ptr{weighted_literal_t}, Csize_t, weight_t, weight_constraint_type_t, Bool, Ptr{Bool}), init, literal, literals, size, bound, type, compare_equal, result)
end

function propagate_init_add_minimize(init, literal, weight, priority)
    @wraperror ccall((:clingo_propagate_init_add_minimize, libclingo), Bool, (Ptr{propagate_init_t}, literal_t, weight_t, weight_t), init, literal, weight, priority)
end

function propagate_init_propagate(init, result)
    @wraperror ccall((:clingo_propagate_init_propagate, libclingo), Bool, (Ptr{propagate_init_t}, Ptr{Bool}), init, result)
end

@enum clause_type_e::UInt32 begin
    clause_type_learnt = 0
    clause_type_static = 1
    clause_type_volatile = 2
    clause_type_volatile_static = 3
end

const clause_type_t = Cint

mutable struct propagate_control_t end

function propagate_control_thread_id(control)
    ccall((:clingo_propagate_control_thread_id, libclingo), id_t, (Ptr{propagate_control_t},), control)
end

function propagate_control_assignment(control)
    ccall((:clingo_propagate_control_assignment, libclingo), Ptr{assignment_t}, (Ptr{propagate_control_t},), control)
end

function propagate_control_add_literal(control, result)
    @wraperror ccall((:clingo_propagate_control_add_literal, libclingo), Bool, (Ptr{propagate_control_t}, Ptr{literal_t}), control, result)
end

function propagate_control_add_watch(control, literal)
    @wraperror ccall((:clingo_propagate_control_add_watch, libclingo), Bool, (Ptr{propagate_control_t}, literal_t), control, literal)
end

function propagate_control_has_watch(control, literal)
    @wraperror ccall((:clingo_propagate_control_has_watch, libclingo), Bool, (Ptr{propagate_control_t}, literal_t), control, literal)
end

function propagate_control_remove_watch(control, literal)
    ccall((:clingo_propagate_control_remove_watch, libclingo), Cvoid, (Ptr{propagate_control_t}, literal_t), control, literal)
end

function propagate_control_add_clause(control, clause, size, type, result)
    @wraperror ccall((:clingo_propagate_control_add_clause, libclingo), Bool, (Ptr{propagate_control_t}, Ptr{literal_t}, Csize_t, clause_type_t, Ptr{Bool}), control, clause, size, type, result)
end

function propagate_control_propagate(control, result)
    @wraperror ccall((:clingo_propagate_control_propagate, libclingo), Bool, (Ptr{propagate_control_t}, Ptr{Bool}), control, result)
end

# typedef bool ( * clingo_propagator_init_callback_t ) ( clingo_propagate_init_t * , void * )
const propagator_init_callback_t = Ptr{Cvoid}

# typedef bool ( * clingo_propagator_propagate_callback_t ) ( clingo_propagate_control_t * , literal_t const * , size_t , void * )
const propagator_propagate_callback_t = Ptr{Cvoid}

# typedef void ( * clingo_propagator_undo_callback_t ) ( clingo_propagate_control_t const * , literal_t const * , size_t , void * )
const propagator_undo_callback_t = Ptr{Cvoid}

# typedef bool ( * clingo_propagator_check_callback_t ) ( clingo_propagate_control_t * , void * )
const propagator_check_callback_t = Ptr{Cvoid}

struct clingo_propagator
    init::Ptr{Cvoid}
    propagate::Ptr{Cvoid}
    undo::Ptr{Cvoid}
    check::Ptr{Cvoid}
    decide::Ptr{Cvoid}
end

const propagator_t = clingo_propagator

@enum heuristic_type_e::UInt32 begin
    heuristic_type_level = 0
    heuristic_type_sign = 1
    heuristic_type_factor = 2
    heuristic_type_init = 3
    heuristic_type_true = 4
    heuristic_type_false = 5
end

const heuristic_type_t = Cint

@enum external_type_e::UInt32 begin
    external_type_free = 0
    external_type_true = 1
    external_type_false = 2
    external_type_release = 3
end

const external_type_t = Cint

mutable struct backend_t end

function backend_begin(backend)
    @wraperror ccall((:clingo_backend_begin, libclingo), Bool, (Ptr{backend_t},), backend)
end

function backend_end(backend)
    @wraperror ccall((:clingo_backend_end, libclingo), Bool, (Ptr{backend_t},), backend)
end

function backend_rule(backend, choice, head, head_size, body, body_size)
    @wraperror ccall((:clingo_backend_rule, libclingo), Bool, (Ptr{backend_t}, Bool, Ptr{atom_t}, Csize_t, Ptr{literal_t}, Csize_t), backend, choice, head, head_size, body, body_size)
end

function backend_weight_rule(backend, choice, head, head_size, lower_bound, body, body_size)
    @wraperror ccall((:clingo_backend_weight_rule, libclingo), Bool, (Ptr{backend_t}, Bool, Ptr{atom_t}, Csize_t, weight_t, Ptr{weighted_literal_t}, Csize_t), backend, choice, head, head_size, lower_bound, body, body_size)
end

function backend_minimize(backend, priority, literals, size)
    @wraperror ccall((:clingo_backend_minimize, libclingo), Bool, (Ptr{backend_t}, weight_t, Ptr{weighted_literal_t}, Csize_t), backend, priority, literals, size)
end

function backend_project(backend, atoms, size)
    @wraperror ccall((:clingo_backend_project, libclingo), Bool, (Ptr{backend_t}, Ptr{atom_t}, Csize_t), backend, atoms, size)
end

function backend_external(backend, atom, type)
    @wraperror ccall((:clingo_backend_external, libclingo), Bool, (Ptr{backend_t}, atom_t, external_type_t), backend, atom, type)
end

function backend_assume(backend, literals, size)
    @wraperror ccall((:clingo_backend_assume, libclingo), Bool, (Ptr{backend_t}, Ptr{literal_t}, Csize_t), backend, literals, size)
end

function backend_heuristic(backend, atom, type, bias, priority, condition, size)
    @wraperror ccall((:clingo_backend_heuristic, libclingo), Bool, (Ptr{backend_t}, atom_t, heuristic_type_t, Cint, Cuint, Ptr{literal_t}, Csize_t), backend, atom, type, bias, priority, condition, size)
end

function backend_acyc_edge(backend, node_u, node_v, condition, size)
    @wraperror ccall((:clingo_backend_acyc_edge, libclingo), Bool, (Ptr{backend_t}, Cint, Cint, Ptr{literal_t}, Csize_t), backend, node_u, node_v, condition, size)
end

function backend_add_atom(backend, symbol, atom)
    @wraperror ccall((:clingo_backend_add_atom, libclingo), Bool, (Ptr{backend_t}, Ptr{symbol_t}, Ptr{atom_t}), backend, symbol, atom)
end

@enum configuration_type_e::UInt32 begin
    configuration_type_value = 1
    configuration_type_array = 2
    configuration_type_map = 4
end

const configuration_type_bitset_t = Cuint

mutable struct configuration_t end

function configuration_root(configuration)
    key = Ref{id_t}()
    @wraperror ccall((:clingo_configuration_root, libclingo), Bool, (Ptr{configuration_t}, Ptr{id_t}), configuration, key)
    return key[]
end

function configuration_type(configuration, key)
    type = Ref{configuration_type_bitset_t}()
    @wraperror ccall((:clingo_configuration_type, libclingo), Bool, (Ptr{configuration_t}, id_t, Ptr{configuration_type_bitset_t}), configuration, key, type)
    return type[]
end

function configuration_description(configuration, key)
    v = Vector{String}()
    @wraperror ccall((:clingo_configuration_description, libclingo), Bool, (Ptr{configuration_t}, id_t, Ptr{Ptr{Cchar}}), configuration, key, v)
    return v
end

function configuration_array_size(configuration, key, size)
    @wraperror ccall((:clingo_configuration_array_size, libclingo), Bool, (Ptr{configuration_t}, id_t, Ptr{Csize_t}), configuration, key, size)
end

function configuration_array_at(configuration, key, offset, subkey)
    @wraperror ccall((:clingo_configuration_array_at, libclingo), Bool, (Ptr{configuration_t}, id_t, Csize_t, Ptr{id_t}), configuration, key, offset, subkey)
end

function configuration_map_size(configuration, key)
    size = Ref{Csize_t}(0)
    @wraperror ccall((:clingo_configuration_map_size, libclingo), Bool, (Ptr{configuration_t}, id_t, Ptr{Csize_t}), configuration, key, size)
    return size[]
end

function configuration_map_has_subkey(configuration, key, name)
    result = Ref{Bool}(false)
    @wraperror ccall((:clingo_configuration_map_has_subkey, libclingo), Bool, (Ptr{configuration_t}, id_t, Cstring, Ptr{Bool}), configuration, key, name, result)
    return result[]
end

function configuration_map_subkey_name(configuration, key, offset)
    name = Ref{Ptr{Cchar}}()
    @wraperror ccall((:clingo_configuration_map_subkey_name, libclingo), Bool, (Ptr{configuration_t}, id_t, Csize_t, Ptr{Ptr{Cchar}}), configuration, key, offset, name)
    return @GC.preserve unsafe_string(name[])
end

function configuration_map_at(configuration, key, name)
    subkey = Ref{id_t}()
    @wraperror ccall((:clingo_configuration_map_at, libclingo), Bool, (Ptr{configuration_t}, id_t, Cstring, Ptr{id_t}), configuration, key, name, subkey)
    return subkey[]
end

function configuration_value_is_assigned(configuration, key)
    assigned = Ref{Bool}(false)
    @wraperror ccall((:clingo_configuration_value_is_assigned, libclingo), Bool, (Ptr{configuration_t}, id_t, Ptr{Bool}), configuration, key, assigned)
    return assigned[]
end

function configuration_value_get_size(configuration, key)
    size = Ref{Csize_t}(0)
    @wraperror ccall((:clingo_configuration_value_get_size, libclingo), Bool, (Ptr{configuration_t}, id_t, Ptr{Csize_t}), configuration, key, size)
    return size[]
end

function configuration_value_get(configuration, key)
    size = configuration_value_get_size(configuration, key)
    value = Vector{Cchar}(size, undef)
    @wraperror ccall((:clingo_configuration_value_get, libclingo), Bool, (Ptr{configuration_t}, id_t, Cstring, Csize_t), configuration, key, value, size)
    return @GC.preserve unsafe_string(value)
end

function configuration_value_set(configuration, key, value)
    @wraperror ccall((:clingo_configuration_value_set, libclingo), Bool, (Ptr{configuration_t}, id_t, Cstring), configuration, key, value)
end

@enum statistics_type_e::UInt32 begin
    statistics_type_empty = 0
    statistics_type_value = 1
    statistics_type_array = 2
    statistics_type_map = 3
end

const statistics_type_t = Cint

mutable struct statistics_t end

function statistics_root(statistics, key)
    @wraperror ccall((:clingo_statistics_root, libclingo), Bool, (Ptr{statistics_t}, Ptr{UInt64}), statistics, key)
end

function statistics_type(statistics, key, type)
    @wraperror ccall((:clingo_statistics_type, libclingo), Bool, (Ptr{statistics_t}, UInt64, Ptr{statistics_type_t}), statistics, key, type)
end

function statistics_array_size(statistics, key, size)
    @wraperror ccall((:clingo_statistics_array_size, libclingo), Bool, (Ptr{statistics_t}, UInt64, Ptr{Csize_t}), statistics, key, size)
end

function statistics_array_at(statistics, key, offset, subkey)
    @wraperror ccall((:clingo_statistics_array_at, libclingo), Bool, (Ptr{statistics_t}, UInt64, Csize_t, Ptr{UInt64}), statistics, key, offset, subkey)
end

function statistics_array_push(statistics, key, type, subkey)
    @wraperror ccall((:clingo_statistics_array_push, libclingo), Bool, (Ptr{statistics_t}, UInt64, statistics_type_t, Ptr{UInt64}), statistics, key, type, subkey)
end

function statistics_map_size(statistics, key, size)
    @wraperror ccall((:clingo_statistics_map_size, libclingo), Bool, (Ptr{statistics_t}, UInt64, Ptr{Csize_t}), statistics, key, size)
end

function statistics_map_has_subkey(statistics, key, name, result)
    @wraperror ccall((:clingo_statistics_map_has_subkey, libclingo), Bool, (Ptr{statistics_t}, UInt64, Cstring, Ptr{Bool}), statistics, key, name, result)
end

function statistics_map_subkey_name(statistics, key, offset, name)
    @wraperror ccall((:clingo_statistics_map_subkey_name, libclingo), Bool, (Ptr{statistics_t}, UInt64, Csize_t, Ptr{Ptr{Cchar}}), statistics, key, offset, name)
end

function statistics_map_at(statistics, key, name, subkey)
    @wraperror ccall((:clingo_statistics_map_at, libclingo), Bool, (Ptr{statistics_t}, UInt64, Cstring, Ptr{UInt64}), statistics, key, name, subkey)
end

function statistics_map_add_subkey(statistics, key, name, type, subkey)
    @wraperror ccall((:clingo_statistics_map_add_subkey, libclingo), Bool, (Ptr{statistics_t}, UInt64, Cstring, statistics_type_t, Ptr{UInt64}), statistics, key, name, type, subkey)
end

function statistics_value_get(statistics, key, value)
    @wraperror ccall((:clingo_statistics_value_get, libclingo), Bool, (Ptr{statistics_t}, UInt64, Ptr{Cdouble}), statistics, key, value)
end

function statistics_value_set(statistics, key, value)
    @wraperror ccall((:clingo_statistics_value_set, libclingo), Bool, (Ptr{statistics_t}, UInt64, Cdouble), statistics, key, value)
end

mutable struct solve_control_t end

mutable struct model_t end

@enum model_type_e::UInt32 begin
    model_type_stable_model = 0
    model_type_brave_consequences = 1
    model_type_cautious_consequences = 2
end

const model_type_t = Cint

@enum show_type_e::UInt32 begin
    show_type_csp = 1
    show_type_shown = 2
    show_type_atoms = 4
    show_type_terms = 8
    show_type_theory = 16
    show_type_all = 31
    show_type_complement = 32
end

const show_type_bitset_t = Cuint

function model_type(model, type)
    @wraperror ccall((:clingo_model_type, libclingo), Bool, (Ptr{model_t}, Ptr{model_type_t}), model, type)
end

function model_number(model, number)
    @wraperror ccall((:clingo_model_number, libclingo), Bool, (Ptr{model_t}, Ptr{UInt64}), model, number)
end

function model_symbols_size(model, show, size)
    @wraperror ccall((:clingo_model_symbols_size, libclingo), Bool, (Ptr{model_t}, show_type_bitset_t, Ptr{Csize_t}), model, show, size)
end

function model_symbols(model, show, symbols, size)
    @wraperror ccall((:clingo_model_symbols, libclingo), Bool, (Ptr{model_t}, show_type_bitset_t, Ptr{symbol_t}, Csize_t), model, show, symbols, size)
end

function model_contains(model, atom, contained)
    @wraperror ccall((:clingo_model_contains, libclingo), Bool, (Ptr{model_t}, symbol_t, Ptr{Bool}), model, atom, contained)
end

function model_is_true(model, literal, result)
    @wraperror ccall((:clingo_model_is_true, libclingo), Bool, (Ptr{model_t}, literal_t, Ptr{Bool}), model, literal, result)
end

function model_cost_size(model, size)
    @wraperror ccall((:clingo_model_cost_size, libclingo), Bool, (Ptr{model_t}, Ptr{Csize_t}), model, size)
end

function model_cost(model, costs, size)
    @wraperror ccall((:clingo_model_cost, libclingo), Bool, (Ptr{model_t}, Ptr{Int64}, Csize_t), model, costs, size)
end

function model_optimality_proven(model, proven)
    @wraperror ccall((:clingo_model_optimality_proven, libclingo), Bool, (Ptr{model_t}, Ptr{Bool}), model, proven)
end

function model_thread_id(model, id)
    @wraperror ccall((:clingo_model_thread_id, libclingo), Bool, (Ptr{model_t}, Ptr{id_t}), model, id)
end

function model_extend(model, symbols, size)
    @wraperror ccall((:clingo_model_extend, libclingo), Bool, (Ptr{model_t}, Ptr{symbol_t}, Csize_t), model, symbols, size)
end

function model_context(model, control)
    @wraperror ccall((:clingo_model_context, libclingo), Bool, (Ptr{model_t}, Ptr{Ptr{solve_control_t}}), model, control)
end

function solve_control_symbolic_atoms(control, atoms)
    @wraperror ccall((:clingo_solve_control_symbolic_atoms, libclingo), Bool, (Ptr{solve_control_t}, Ptr{Ptr{symbolic_atoms_t}}), control, atoms)
end

function solve_control_add_clause(control, clause, size)
    @wraperror ccall((:clingo_solve_control_add_clause, libclingo), Bool, (Ptr{solve_control_t}, Ptr{literal_t}, Csize_t), control, clause, size)
end

@enum solve_result_e::UInt32 begin
    solve_result_satisfiable = 1
    solve_result_unsatisfiable = 2
    solve_result_exhausted = 4
    solve_result_interrupted = 8
end

const solve_result_bitset_t = Cuint

@enum solve_mode_e::UInt32 begin
    solve_mode_async = 1
    solve_mode_yield = 2
end

const solve_mode_bitset_t = Cuint

@enum solve_event_type_e::UInt32 begin
    solve_event_type_model = 0
    solve_event_type_unsat = 1
    solve_event_type_statistics = 2
    solve_event_type_finish = 3
end

const solve_event_type_t = Cuint

# typedef bool ( * solve_event_callback_t ) ( clingo_solve_event_type_t type , void * event , void * data , bool * goon )
const solve_event_callback_t = Ptr{Cvoid}

mutable struct solve_handle_t end

function solve_handle_get(handle)
    result = Ref{solve_result_bitset_t}(0)
    @wraperror ccall((:clingo_solve_handle_get, libclingo), Bool, (Ptr{solve_handle_t}, Ptr{solve_result_bitset_t}), handle, result)
    return solve_result_e(result[])
end

function solve_handle_wait(handle, timeout, result)
    ccall((:clingo_solve_handle_wait, libclingo), Cvoid, (Ptr{solve_handle_t}, Cdouble, Ptr{Bool}), handle, timeout, result)
end

function solve_handle_model(handle, model)
    @wraperror ccall((:clingo_solve_handle_model, libclingo), Bool, (Ptr{solve_handle_t}, Ptr{Ptr{model_t}}), handle, model)
end

function solve_handle_core(handle, core, size)
    @wraperror ccall((:clingo_solve_handle_core, libclingo), Bool, (Ptr{solve_handle_t}, Ptr{Ptr{literal_t}}, Ptr{Csize_t}), handle, core, size)
end

function solve_handle_resume(handle)
    @wraperror ccall((:clingo_solve_handle_resume, libclingo), Bool, (Ptr{solve_handle_t},), handle)
end

function solve_handle_cancel(handle)
    @wraperror ccall((:clingo_solve_handle_cancel, libclingo), Bool, (Ptr{solve_handle_t},), handle)
end

function solve_handle_close(handle)
    @wraperror ccall((:clingo_solve_handle_close, libclingo), Bool, (Ptr{solve_handle_t},), handle)
end

@enum ast_theory_sequence_type_e::UInt32 begin
    ast_theory_sequence_type_tuple = 0
    ast_theory_sequence_type_list = 1
    ast_theory_sequence_type_set = 2
end

const ast_theory_sequence_type_t = Cint

@enum ast_comparison_operator_e::UInt32 begin
    ast_comparison_sequence_type_greater_than = 0
    ast_comparison_sequence_type_less_than = 1
    ast_comparison_sequence_type_less_equal = 2
    ast_comparison_sequence_type_greater_equal = 3
    ast_comparison_sequence_type_not_equal = 4
    ast_comparison_sequence_type_equal = 5
end

const ast_comparison_operator_t = Cint

@enum ast_sign_e::UInt32 begin
    ast_sign_no_sign = 0
    ast_sign_negation = 1
    ast_sign_double_negation = 2
end

const ast_sign_t = Cint

@enum ast_unary_operator_e::UInt32 begin
    ast_unary_operator_minus = 0
    ast_unary_operator_negation = 1
    ast_unary_operator_absolute = 2
end

const ast_unary_operator_t = Cint

@enum ast_binary_operator_e::UInt32 begin
    ast_binary_operator_xor = 0
    ast_binary_operator_or = 1
    ast_binary_operator_and = 2
    ast_binary_operator_plus = 3
    ast_binary_operator_minus = 4
    ast_binary_operator_multiplication = 5
    ast_binary_operator_division = 6
    ast_binary_operator_modulo = 7
    ast_binary_operator_power = 8
end

const ast_binary_operator_t = Cint

@enum ast_aggregate_function_e::UInt32 begin
    ast_aggregate_function_count = 0
    ast_aggregate_function_sum = 1
    ast_aggregate_function_sump = 2
    ast_aggregate_function_min = 3
    ast_aggregate_function_max = 4
end

const ast_aggregate_function_t = Cint

@enum ast_theory_operator_type_e::UInt32 begin
    ast_theory_operator_type_unary = 0
    ast_theory_operator_type_binary_left = 1
    ast_theory_operator_type_binary_right = 2
end

const ast_theory_operator_type_t = Cint

@enum ast_theory_atom_definition_type_e::UInt32 begin
    ast_theory_atom_definition_type_head = 0
    ast_theory_atom_definition_type_body = 1
    ast_theory_atom_definition_type_any = 2
    ast_theory_atom_definition_type_directive = 3
end

const ast_theory_atom_definition_type_t = Cint

@enum ast_type_e::UInt32 begin
    ast_type_id = 0
    ast_type_variable = 1
    ast_type_symbolic_term = 2
    ast_type_unary_operation = 3
    ast_type_binary_operation = 4
    ast_type_interval = 5
    ast_type_function = 6
    ast_type_pool = 7
    ast_type_csp_product = 8
    ast_type_csp_sum = 9
    ast_type_csp_guard = 10
    ast_type_boolean_constant = 11
    ast_type_symbolic_atom = 12
    ast_type_comparison = 13
    ast_type_csp_literal = 14
    ast_type_aggregate_guard = 15
    ast_type_conditional_literal = 16
    ast_type_aggregate = 17
    ast_type_body_aggregate_element = 18
    ast_type_body_aggregate = 19
    ast_type_head_aggregate_element = 20
    ast_type_head_aggregate = 21
    ast_type_disjunction = 22
    ast_type_disjoint_element = 23
    ast_type_disjoint = 24
    ast_type_theory_sequence = 25
    ast_type_theory_function = 26
    ast_type_theory_unparsed_term_element = 27
    ast_type_theory_unparsed_term = 28
    ast_type_theory_guard = 29
    ast_type_theory_atom_element = 30
    ast_type_theory_atom = 31
    ast_type_literal = 32
    ast_type_theory_operator_definition = 33
    ast_type_theory_term_definition = 34
    ast_type_theory_guard_definition = 35
    ast_type_theory_atom_definition = 36
    ast_type_rule = 37
    ast_type_definition = 38
    ast_type_show_signature = 39
    ast_type_show_term = 40
    ast_type_minimize = 41
    ast_type_script = 42
    ast_type_program = 43
    ast_type_external = 44
    ast_type_edge = 45
    ast_type_heuristic = 46
    ast_type_project_atom = 47
    ast_type_project_signature = 48
    ast_type_defined = 49
    ast_type_theory_definition = 50
end

const ast_type_t = Cint

@enum ast_attribute_type_e::UInt32 begin
    ast_attribute_type_number = 0
    ast_attribute_type_symbol = 1
    ast_attribute_type_location = 2
    ast_attribute_type_string = 3
    ast_attribute_type_ast = 4
    ast_attribute_type_optional_ast = 5
    ast_attribute_type_string_array = 6
    ast_attribute_type_ast_array = 7
end

const ast_attribute_type_t = Cint

@enum ast_attribute_e::UInt32 begin
    ast_attribute_argument = 0
    ast_attribute_arguments = 1
    ast_attribute_arity = 2
    ast_attribute_atom = 3
    ast_attribute_atoms = 4
    ast_attribute_atom_type = 5
    ast_attribute_bias = 6
    ast_attribute_body = 7
    ast_attribute_code = 8
    ast_attribute_coefficient = 9
    ast_attribute_comparison = 10
    ast_attribute_condition = 11
    ast_attribute_csp = 12
    ast_attribute_elements = 13
    ast_attribute_external = 14
    ast_attribute_external_type = 15
    ast_attribute_clingo_function = 16
    ast_attribute_guard = 17
    ast_attribute_guards = 18
    ast_attribute_head = 19
    ast_attribute_is_default = 20
    ast_attribute_left = 21
    ast_attribute_left_guard = 22
    ast_attribute_literal = 23
    ast_attribute_location = 24
    ast_attribute_modifier = 25
    ast_attribute_name = 26
    ast_attribute_node_u = 27
    ast_attribute_node_v = 28
    ast_attribute_operator_name = 29
    ast_attribute_operator_type = 30
    ast_attribute_operators = 31
    ast_attribute_parameters = 32
    ast_attribute_positive = 33
    ast_attribute_priority = 34
    ast_attribute_right = 35
    ast_attribute_right_guard = 36
    ast_attribute_sequence_type = 37
    ast_attribute_sign = 38
    ast_attribute_symbol = 39
    ast_attribute_term = 40
    ast_attribute_terms = 41
    ast_attribute_value = 42
    ast_attribute_variable = 43
    ast_attribute_weight = 44
end

const ast_attribute_t = Cint

struct ast_attribute_names
    names::Ptr{Ptr{Cchar}}
    size::Csize_t
end

const ast_attribute_names_t = ast_attribute_names

struct ast_argument
    attribute::ast_attribute_t
    type::ast_attribute_type_t
end

const ast_argument_t = ast_argument

struct ast_constructor
    name::Cstring
    arguments::Ptr{ast_argument_t}
    size::Csize_t
end

const ast_constructor_t = ast_constructor

struct ast_constructors
    constructors::Ptr{ast_constructor_t}
    size::Csize_t
end

const ast_constructors_t = ast_constructors

mutable struct ast_t end

function ast_acquire(ast)
    ccall((:clingo_ast_acquire, libclingo), Cvoid, (Ptr{ast_t},), ast)
end

function ast_release(ast)
    ccall((:clingo_ast_release, libclingo), Cvoid, (Ptr{ast_t},), ast)
end

function ast_copy(ast, copy)
    @wraperror ccall((:clingo_ast_copy, libclingo), Bool, (Ptr{ast_t}, Ptr{Ptr{ast_t}}), ast, copy)
end

function ast_deep_copy(ast, copy)
    @wraperror ccall((:clingo_ast_deep_copy, libclingo), Bool, (Ptr{ast_t}, Ptr{Ptr{ast_t}}), ast, copy)
end

function ast_less_than(a, b)
    @wraperror ccall((:clingo_ast_less_than, libclingo), Bool, (Ptr{ast_t}, Ptr{ast_t}), a, b)
end

function ast_equal(a, b)
    @wraperror ccall((:clingo_ast_equal, libclingo), Bool, (Ptr{ast_t}, Ptr{ast_t}), a, b)
end

function ast_hash(ast)
    ccall((:clingo_ast_hash, libclingo), Csize_t, (Ptr{ast_t},), ast)
end

function ast_to_string_size(ast, size)
    @wraperror ccall((:clingo_ast_to_string_size, libclingo), Bool, (Ptr{ast_t}, Ptr{Csize_t}), ast, size)
end

function ast_to_string(ast, string, size)
    @wraperror ccall((:clingo_ast_to_string, libclingo), Bool, (Ptr{ast_t}, Cstring, Csize_t), ast, string, size)
end

function ast_get_type(ast, type)
    @wraperror ccall((:clingo_ast_get_type, libclingo), Bool, (Ptr{ast_t}, Ptr{ast_type_t}), ast, type)
end

function ast_has_attribute(ast, attribute, has_attribute)
    @wraperror ccall((:clingo_ast_has_attribute, libclingo), Bool, (Ptr{ast_t}, ast_attribute_t, Ptr{Bool}), ast, attribute, has_attribute)
end

function ast_attribute_type(ast, attribute, type)
    @wraperror ccall((:clingo_ast_attribute_type, libclingo), Bool, (Ptr{ast_t}, ast_attribute_t, Ptr{ast_attribute_type_t}), ast, attribute, type)
end

function ast_attribute_get_number(ast, attribute, value)
    @wraperror ccall((:clingo_ast_attribute_get_number, libclingo), Bool, (Ptr{ast_t}, ast_attribute_t, Ptr{Cint}), ast, attribute, value)
end

function ast_attribute_set_number(ast, attribute, value)
    @wraperror ccall((:clingo_ast_attribute_set_number, libclingo), Bool, (Ptr{ast_t}, ast_attribute_t, Cint), ast, attribute, value)
end

function ast_attribute_get_symbol(ast, attribute, value)
    @wraperror ccall((:clingo_ast_attribute_get_symbol, libclingo), Bool, (Ptr{ast_t}, ast_attribute_t, Ptr{symbol_t}), ast, attribute, value)
end

function ast_attribute_set_symbol(ast, attribute, value)
    @wraperror ccall((:clingo_ast_attribute_set_symbol, libclingo), Bool, (Ptr{ast_t}, ast_attribute_t, symbol_t), ast, attribute, value)
end

function ast_attribute_get_location(ast, attribute, value)
    @wraperror ccall((:clingo_ast_attribute_get_location, libclingo), Bool, (Ptr{ast_t}, ast_attribute_t, Ptr{location_t}), ast, attribute, value)
end

function ast_attribute_set_location(ast, attribute, value)
    @wraperror ccall((:clingo_ast_attribute_set_location, libclingo), Bool, (Ptr{ast_t}, ast_attribute_t, Ptr{location_t}), ast, attribute, value)
end

function ast_attribute_get_string(ast, attribute, value)
    @wraperror ccall((:clingo_ast_attribute_get_string, libclingo), Bool, (Ptr{ast_t}, ast_attribute_t, Ptr{Ptr{Cchar}}), ast, attribute, value)
end

function ast_attribute_set_string(ast, attribute, value)
    @wraperror ccall((:clingo_ast_attribute_set_string, libclingo), Bool, (Ptr{ast_t}, ast_attribute_t, Cstring), ast, attribute, value)
end

function ast_attribute_get_ast(ast, attribute, value)
    @wraperror ccall((:clingo_ast_attribute_get_ast, libclingo), Bool, (Ptr{ast_t}, ast_attribute_t, Ptr{Ptr{ast_t}}), ast, attribute, value)
end

function ast_attribute_set_ast(ast, attribute, value)
    @wraperror ccall((:clingo_ast_attribute_set_ast, libclingo), Bool, (Ptr{ast_t}, ast_attribute_t, Ptr{ast_t}), ast, attribute, value)
end

function ast_attribute_get_optional_ast(ast, attribute, value)
    @wraperror ccall((:clingo_ast_attribute_get_optional_ast, libclingo), Bool, (Ptr{ast_t}, ast_attribute_t, Ptr{Ptr{ast_t}}), ast, attribute, value)
end

function ast_attribute_set_optional_ast(ast, attribute, value)
    @wraperror ccall((:clingo_ast_attribute_set_optional_ast, libclingo), Bool, (Ptr{ast_t}, ast_attribute_t, Ptr{ast_t}), ast, attribute, value)
end

function ast_attribute_get_string_at(ast, attribute, index, value)
    @wraperror ccall((:clingo_ast_attribute_get_string_at, libclingo), Bool, (Ptr{ast_t}, ast_attribute_t, Csize_t, Ptr{Ptr{Cchar}}), ast, attribute, index, value)
end

function ast_attribute_set_string_at(ast, attribute, index, value)
    @wraperror ccall((:clingo_ast_attribute_set_string_at, libclingo), Bool, (Ptr{ast_t}, ast_attribute_t, Csize_t, Cstring), ast, attribute, index, value)
end

function ast_attribute_delete_string_at(ast, attribute, index)
    @wraperror ccall((:clingo_ast_attribute_delete_string_at, libclingo), Bool, (Ptr{ast_t}, ast_attribute_t, Csize_t), ast, attribute, index)
end

function ast_attribute_size_string_array(ast, attribute, size)
    @wraperror ccall((:clingo_ast_attribute_size_string_array, libclingo), Bool, (Ptr{ast_t}, ast_attribute_t, Ptr{Csize_t}), ast, attribute, size)
end

function ast_attribute_insert_string_at(ast, attribute, index, value)
    @wraperror ccall((:clingo_ast_attribute_insert_string_at, libclingo), Bool, (Ptr{ast_t}, ast_attribute_t, Csize_t, Cstring), ast, attribute, index, value)
end

function ast_attribute_get_ast_at(ast, attribute, index, value)
    @wraperror ccall((:clingo_ast_attribute_get_ast_at, libclingo), Bool, (Ptr{ast_t}, ast_attribute_t, Csize_t, Ptr{Ptr{ast_t}}), ast, attribute, index, value)
end

function ast_attribute_set_ast_at(ast, attribute, index, value)
    @wraperror ccall((:clingo_ast_attribute_set_ast_at, libclingo), Bool, (Ptr{ast_t}, ast_attribute_t, Csize_t, Ptr{ast_t}), ast, attribute, index, value)
end

function ast_attribute_delete_ast_at(ast, attribute, index)
    @wraperror ccall((:clingo_ast_attribute_delete_ast_at, libclingo), Bool, (Ptr{ast_t}, ast_attribute_t, Csize_t), ast, attribute, index)
end

function ast_attribute_size_ast_array(ast, attribute, size)
    @wraperror ccall((:clingo_ast_attribute_size_ast_array, libclingo), Bool, (Ptr{ast_t}, ast_attribute_t, Ptr{Csize_t}), ast, attribute, size)
end

function ast_attribute_insert_ast_at(ast, attribute, index, value)
    @wraperror ccall((:clingo_ast_attribute_insert_ast_at, libclingo), Bool, (Ptr{ast_t}, ast_attribute_t, Csize_t, Ptr{ast_t}), ast, attribute, index, value)
end

# typedef bool ( * ast_callback_t ) ( clingo_ast_t * ast , void * data )
const ast_callback_t = Ptr{Cvoid}

function ast_parse_string(program, callback, callback_data, logger, logger_data, message_limit)
    @wraperror ccall((:clingo_ast_parse_string, libclingo), Bool, (Cstring, ast_callback_t, Ptr{Cvoid}, logger_t, Ptr{Cvoid}, Cuint), program, callback, callback_data, logger, logger_data, message_limit)
end

function ast_parse_files(files, size, callback, callback_data, logger, logger_data, message_limit)
    @wraperror ccall((:clingo_ast_parse_files, libclingo), Bool, (Ptr{Ptr{Cchar}}, Csize_t, ast_callback_t, Ptr{Cvoid}, logger_t, Ptr{Cvoid}, Cuint), files, size, callback, callback_data, logger, logger_data, message_limit)
end

mutable struct program_builder_t end

function program_builder_begin(builder)
    @wraperror ccall((:clingo_program_builder_begin, libclingo), Bool, (Ptr{program_builder_t},), builder)
end

function program_builder_end(builder)
    @wraperror ccall((:clingo_program_builder_end, libclingo), Bool, (Ptr{program_builder_t},), builder)
end

function program_builder_add(builder, ast)
    @wraperror ccall((:clingo_program_builder_add, libclingo), Bool, (Ptr{program_builder_t}, Ptr{ast_t}), builder, ast)
end

@enum ast_unpool_type_e::UInt32 begin
    ast_unpool_type_condition = 1
    ast_unpool_type_other = 2
    ast_unpool_type_all = 3
end

const ast_unpool_type_bitset_t = Cint

function ast_unpool(ast, unpool_type, callback, callback_data)
    @wraperror ccall((:clingo_ast_unpool, libclingo), Bool, (Ptr{ast_t}, ast_unpool_type_bitset_t, ast_callback_t, Ptr{Cvoid}), ast, unpool_type, callback, callback_data)
end

struct ground_program_observer
    init_program::Ptr{Cvoid}
    begin_step::Ptr{Cvoid}
    end_step::Ptr{Cvoid}
    rule::Ptr{Cvoid}
    weight_rule::Ptr{Cvoid}
    minimize::Ptr{Cvoid}
    project::Ptr{Cvoid}
    output_atom::Ptr{Cvoid}
    output_term::Ptr{Cvoid}
    output_csp::Ptr{Cvoid}
    external::Ptr{Cvoid}
    assume::Ptr{Cvoid}
    heuristic::Ptr{Cvoid}
    acyc_edge::Ptr{Cvoid}
    theory_term_number::Ptr{Cvoid}
    theory_term_string::Ptr{Cvoid}
    theory_term_compound::Ptr{Cvoid}
    theory_element::Ptr{Cvoid}
    theory_atom::Ptr{Cvoid}
    theory_atom_with_guard::Ptr{Cvoid}
end

const ground_program_observer_t = ground_program_observer

struct clingo_part
    name::String
    params::Ptr{symbol_t}
    size::Csize_t
end

const part_t = clingo_part

# typedef bool ( * ground_callback_t ) ( location_t const * location , char const * name , clingo_symbol_t const * arguments , size_t arguments_size , void * data , clingo_symbol_callback_t symbol_callback , void * symbol_callback_data )
const ground_callback_t = Ptr{Cvoid}

mutable struct control_t end

function control_new(arguments, arguments_size, logger, logger_data, message_limit)
    control = Ref(Ptr{control_t}())
    @wraperror ccall((:clingo_control_new, libclingo), Bool, (Ptr{Ptr{Cchar}}, Csize_t, logger_t, Ptr{Cvoid}, Cuint, Ptr{Ptr{control_t}}), arguments, arguments_size, logger, logger_data, message_limit, control)
    return control[]
end

function control_free(control)
    ccall((:clingo_control_free, libclingo), Cvoid, (Ptr{control_t},), control)
end

function control_load(control, file)
    @wraperror ccall((:clingo_control_load, libclingo), Bool, (Ptr{control_t}, Cstring), control, file)
end

function control_add(control, name, parameters, parameters_size, program)
    @wraperror ccall((:clingo_control_add, libclingo), Bool, (Ptr{control_t}, Cstring, Ptr{Ptr{Cchar}}, Csize_t, Cstring), control, name, parameters, parameters_size, program)
end

function control_ground(control, parts, parts_size, ground_callback, ground_callback_data)
    @wraperror ccall((:clingo_control_ground, libclingo), Bool, (Ptr{control_t}, Ptr{part_t}, Csize_t, ground_callback_t, Ptr{Cvoid}), control, parts, parts_size, ground_callback, ground_callback_data)
end

function control_solve(control, mode, assumptions, assumptions_size, notify, data)
    handle = Ref(Ptr{clingo_solve_handle}())
    @wraperror ccall((:clingo_control_solve, libclingo), Bool, (Ptr{control_t}, solve_mode_bitset_t, Ptr{literal_t}, Csize_t, solve_event_callback_t, Ptr{Cvoid}, Ptr{Ptr{solve_handle_t}}), control, mode, assumptions, assumptions_size, notify, data, handle)
    return handle[]
end

function control_cleanup(control)
    @wraperror ccall((:clingo_control_cleanup, libclingo), Bool, (Ptr{control_t},), control)
end

function control_assign_external(control, literal, value)
    @wraperror ccall((:clingo_control_assign_external, libclingo), Bool, (Ptr{control_t}, literal_t, truth_value_t), control, literal, value)
end

function control_release_external(control, literal)
    @wraperror ccall((:clingo_control_release_external, libclingo), Bool, (Ptr{control_t}, literal_t), control, literal)
end

function control_register_propagator(control, propagator, data, sequential)
    @wraperror ccall((:clingo_control_register_propagator, libclingo), Bool, (Ptr{control_t}, Ptr{propagator_t}, Ptr{Cvoid}, Bool), control, propagator, data, sequential)
end

function control_is_conflicting(control)
    @wraperror ccall((:clingo_control_is_conflicting, libclingo), Bool, (Ptr{control_t},), control)
end

function control_statistics(control)
    statistics = Ref(Ptr{clingo_statistics}())
    @wraperror ccall((:clingo_control_statistics, libclingo), Bool, (Ptr{control_t}, Ptr{Ptr{statistics_t}}), control, statistics)
    return statistics[]
end

function control_interrupt(control)
    ccall((:clingo_control_interrupt, libclingo), Cvoid, (Ptr{control_t},), control)
end

function control_clasp_facade(control)
    clasp = Ref(Ptr{Cvoid}())
    @wraperror ccall((:clingo_control_clasp_facade, libclingo), Bool, (Ptr{control_t}, Ptr{Ptr{Cvoid}}), control, clasp)
    return clasp[]
end

function control_configuration(control)
    configuration = Ref(Ptr{configuration_t}())
    @wraperror ccall((:clingo_control_configuration, libclingo), Bool, (Ptr{control_t}, Ptr{Ptr{configuration_t}}), control, configuration)
    return configuration[]
end

function control_set_enable_enumeration_assumption(control, enable)
    @wraperror ccall((:clingo_control_set_enable_enumeration_assumption, libclingo), Bool, (Ptr{control_t}, Bool), control, enable)
end

function control_get_enable_enumeration_assumption(control)
    @wraperror ccall((:clingo_control_get_enable_enumeration_assumption, libclingo), Bool, (Ptr{control_t},), control)
end

function control_set_enable_cleanup(control, enable)
    @wraperror ccall((:clingo_control_set_enable_cleanup, libclingo), Bool, (Ptr{control_t}, Bool), control, enable)
end

function control_get_enable_cleanup(control)
    @wraperror ccall((:clingo_control_get_enable_cleanup, libclingo), Bool, (Ptr{control_t},), control)
end

function control_get_const(control, name, symbol)
    @wraperror ccall((:clingo_control_get_const, libclingo), Bool, (Ptr{control_t}, Cstring, Ptr{symbol_t}), control, name, symbol)
end

function control_has_const(control, name, exists)
    @wraperror ccall((:clingo_control_has_const, libclingo), Bool, (Ptr{control_t}, Cstring, Ptr{Bool}), control, name, exists)
end

function control_symbolic_atoms(control)
    atoms = Ref(Ptr{clingo_symbolic_atoms}())
    @wraperror ccall((:clingo_control_symbolic_atoms, libclingo), Bool, (Ptr{control_t}, Ptr{Ptr{symbolic_atoms_t}}), control, atoms)
    return atoms[]
end

function control_theory_atoms(control)
    atoms = Ref(Ptr{clingo_theory_atoms}())
    @wraperror ccall((:clingo_control_theory_atoms, libclingo), Bool, (Ptr{control_t}, Ptr{Ptr{theory_atoms_t}}), control, atoms)
    return atoms[]
end

function control_register_observer(control, observer, replace, data)
    @wraperror ccall((:clingo_control_register_observer, libclingo), Bool, (Ptr{control_t}, Ptr{ground_program_observer_t}, Bool, Ptr{Cvoid}), control, observer, replace, data)
end

function control_backend(control)
    backend = Ref(Ptr{clingo_backend}())
    @wraperror ccall((:clingo_control_backend, libclingo), Bool, (Ptr{control_t}, Ptr{Ptr{backend_t}}), control, backend)
    return backend[]
end

function control_program_builder(control)
    builder = Ref(Ptr{clingo_program_builder}())
    @wraperror ccall((:clingo_control_program_builder, libclingo), Bool, (Ptr{control_t}, Ptr{Ptr{program_builder_t}}), control, builder)
    return builder[]
end

mutable struct options_t end

# typedef bool ( * main_function_t ) ( clingo_control_t * control , char const * const * files , size_t size , void * data )
const main_function_t = Ptr{Cvoid}

# typedef bool ( * default_model_printer_t ) ( void * data )
const default_model_printer_t = Ptr{Cvoid}

# typedef bool ( * model_printer_t ) ( clingo_model_t const * model , default_model_printer_t printer , void * printer_data , void * data )
const model_printer_t = Ptr{Cvoid}

struct application
    program_name::Ptr{Cvoid}
    version::Ptr{Cvoid}
    message_limit::Ptr{Cvoid}
    main::main_function_t
    logger::logger_t
    printer::model_printer_t
    register_options::Ptr{Cvoid}
    validate_options::Ptr{Cvoid}
end

const application_t = application

function options_add(options, group, option, description, parse, data, multi, argument)
    @wraperror ccall((:clingo_options_add, libclingo), Bool, (Ptr{options_t}, Cstring, Cstring, Cstring, Ptr{Cvoid}, Ptr{Cvoid}, Bool, Cstring), options, group, option, description, parse, data, multi, argument)
end

function options_add_flag(options, group, option, description, target)
    @wraperror ccall((:clingo_options_add_flag, libclingo), Bool, (Ptr{options_t}, Cstring, Cstring, Cstring, Ptr{Bool}), options, group, option, description, target)
end

function main(application, arguments, size, data)
    ccall((:clingo_main, libclingo), Cint, (Ptr{application_t}, Ptr{Ptr{Cchar}}, Csize_t, Ptr{Cvoid}), application, arguments, size, data)
end

struct script
    execute::Ptr{Cvoid}
    call::Ptr{Cvoid}
    callable::Ptr{Cvoid}
    main::Ptr{Cvoid}
    free::Ptr{Cvoid}
    version::Cstring
end

const clingo_script_t = script

function register_script(name, script, data)
    @wraperror ccall((:clingo_register_script, libclingo), Bool, (Cstring, Ptr{clingo_script_t}, Ptr{Cvoid}), name, script, data)
end

function script_version(name)
    ccall((:clingo_script_version, libclingo), Cstring, (Cstring,), name)
end

# Skipping MacroDefinition: CLINGO_VISIBILITY_DEFAULT __attribute__ ( ( visibility ( "default" ) ) )

# Skipping MacroDefinition: CLINGO_VISIBILITY_PRIVATE __attribute__ ( ( visibility ( "hidden" ) ) )

# Skipping MacroDefinition: CLINGO_DEPRECATED __attribute__ ( ( deprecated ) )

const VERSION_MAJOR = 5

const VERSION_MINOR = 5

const VERSION_REVISION = 0

const VERSION = "5.5.0"



mutable struct Control
    p::Ptr{control_t}
end

Base.unsafe_convert(::Type{Ptr{control_t}}, ctl::Control) = ctl.p

function Control(args::Vector{String}, logger = C_NULL, logger_data=C_NULL, message_limit=20)
    c = Control(control_new(args, length(args), logger, logger_data, message_limit))
    function f(ctl)
        control_free(ctl)
        ctl.p = C_NULL
    end
    return finalizer(f, c)
end

function Control()
    return Control(["0"])
end


struct Model
    p::Ptr{model_t}
end
Base.unsafe_convert(::Type{Ptr{model_t}}, m::Model) = m.p

struct Handle
    p::Ptr{solve_handle_t}
end
Base.unsafe_convert(::Type{Ptr{solve_handle_t}}, h::Handle) = h.p

include("configuration.jl")

end # module
