module LibClingo
using Clingo_jll: libclingo
const clingo_literal_t = Int32

const clingo_atom_t = UInt32

const clingo_id_t = UInt32

const clingo_weight_t = Int32

struct clingo_weighted_literal
    literal::clingo_literal_t
    weight::clingo_weight_t
end

const clingo_weighted_literal_t = clingo_weighted_literal

@enum clingo_error_e::UInt32 begin
    clingo_error_success = 0
    clingo_error_runtime = 1
    clingo_error_logic = 2
    clingo_error_bad_alloc = 3
    clingo_error_unknown = 4
end

const clingo_error_t = Cint

function clingo_error_string(code)
    ccall((:clingo_error_string, libclingo), Ptr{Cchar}, (clingo_error_t,), code)
end

# no prototype is found for this function at clingo.h:155:42, please use with caution
function clingo_error_code()
    ccall((:clingo_error_code, libclingo), clingo_error_t, ())
end

# no prototype is found for this function at clingo.h:159:39, please use with caution
function clingo_error_message()
    ccall((:clingo_error_message, libclingo), Ptr{Cchar}, ())
end

function clingo_set_error(code, message)
    ccall((:clingo_set_error, libclingo), Cvoid, (clingo_error_t, Ptr{Cchar}), code, message)
end

@enum clingo_warning_e::UInt32 begin
    clingo_warning_operation_undefined = 0
    clingo_warning_runtime_error = 1
    clingo_warning_atom_undefined = 2
    clingo_warning_file_included = 3
    clingo_warning_variable_unbounded = 4
    clingo_warning_global_variable = 5
    clingo_warning_other = 6
end

const clingo_warning_t = Cint

function clingo_warning_string(code)
    ccall((:clingo_warning_string, libclingo), Ptr{Cchar}, (clingo_warning_t,), code)
end

# typedef void ( * clingo_logger_t ) ( clingo_warning_t code , char const * message , void * data )
const clingo_logger_t = Ptr{Cvoid}

function clingo_version(major, minor, revision)
    ccall((:clingo_version, libclingo), Cvoid, (Ptr{Cint}, Ptr{Cint}, Ptr{Cint}), major, minor, revision)
end

@enum clingo_truth_value_e::UInt32 begin
    clingo_truth_value_free = 0
    clingo_truth_value_true = 1
    clingo_truth_value_false = 2
end

const clingo_truth_value_t = Cint

struct clingo_location
    begin_file::Ptr{Cchar}
    end_file::Ptr{Cchar}
    begin_line::Csize_t
    end_line::Csize_t
    begin_column::Csize_t
    end_column::Csize_t
end

const clingo_location_t = clingo_location

const clingo_signature_t = UInt64

function clingo_signature_create(name, arity, positive, signature)
    ccall((:clingo_signature_create, libclingo), Bool, (Ptr{Cchar}, UInt32, Bool, Ptr{clingo_signature_t}), name, arity, positive, signature)
end

function clingo_signature_name(signature)
    ccall((:clingo_signature_name, libclingo), Ptr{Cchar}, (clingo_signature_t,), signature)
end

function clingo_signature_arity(signature)
    ccall((:clingo_signature_arity, libclingo), UInt32, (clingo_signature_t,), signature)
end

function clingo_signature_is_positive(signature)
    ccall((:clingo_signature_is_positive, libclingo), Bool, (clingo_signature_t,), signature)
end

function clingo_signature_is_negative(signature)
    ccall((:clingo_signature_is_negative, libclingo), Bool, (clingo_signature_t,), signature)
end

function clingo_signature_is_equal_to(a, b)
    ccall((:clingo_signature_is_equal_to, libclingo), Bool, (clingo_signature_t, clingo_signature_t), a, b)
end

function clingo_signature_is_less_than(a, b)
    ccall((:clingo_signature_is_less_than, libclingo), Bool, (clingo_signature_t, clingo_signature_t), a, b)
end

function clingo_signature_hash(signature)
    ccall((:clingo_signature_hash, libclingo), Csize_t, (clingo_signature_t,), signature)
end

@enum clingo_symbol_type_e::UInt32 begin
    clingo_symbol_type_infimum = 0
    clingo_symbol_type_number = 1
    clingo_symbol_type_string = 4
    clingo_symbol_type_function = 5
    clingo_symbol_type_supremum = 7
end

const clingo_symbol_type_t = Cint

const clingo_symbol_t = UInt64

function clingo_symbol_create_number(number, symbol)
    ccall((:clingo_symbol_create_number, libclingo), Cvoid, (Cint, Ptr{clingo_symbol_t}), number, symbol)
end

function clingo_symbol_create_supremum(symbol)
    ccall((:clingo_symbol_create_supremum, libclingo), Cvoid, (Ptr{clingo_symbol_t},), symbol)
end

function clingo_symbol_create_infimum(symbol)
    ccall((:clingo_symbol_create_infimum, libclingo), Cvoid, (Ptr{clingo_symbol_t},), symbol)
end

function clingo_symbol_create_string(string, symbol)
    ccall((:clingo_symbol_create_string, libclingo), Bool, (Ptr{Cchar}, Ptr{clingo_symbol_t}), string, symbol)
end

function clingo_symbol_create_id(name, positive, symbol)
    ccall((:clingo_symbol_create_id, libclingo), Bool, (Ptr{Cchar}, Bool, Ptr{clingo_symbol_t}), name, positive, symbol)
end

function clingo_symbol_create_function(name, arguments, arguments_size, positive, symbol)
    ccall((:clingo_symbol_create_function, libclingo), Bool, (Ptr{Cchar}, Ptr{clingo_symbol_t}, Csize_t, Bool, Ptr{clingo_symbol_t}), name, arguments, arguments_size, positive, symbol)
end

function clingo_symbol_number(symbol, number)
    ccall((:clingo_symbol_number, libclingo), Bool, (clingo_symbol_t, Ptr{Cint}), symbol, number)
end

function clingo_symbol_name(symbol, name)
    ccall((:clingo_symbol_name, libclingo), Bool, (clingo_symbol_t, Ptr{Ptr{Cchar}}), symbol, name)
end

function clingo_symbol_string(symbol, string)
    ccall((:clingo_symbol_string, libclingo), Bool, (clingo_symbol_t, Ptr{Ptr{Cchar}}), symbol, string)
end

function clingo_symbol_is_positive(symbol, positive)
    ccall((:clingo_symbol_is_positive, libclingo), Bool, (clingo_symbol_t, Ptr{Bool}), symbol, positive)
end

function clingo_symbol_is_negative(symbol, negative)
    ccall((:clingo_symbol_is_negative, libclingo), Bool, (clingo_symbol_t, Ptr{Bool}), symbol, negative)
end

function clingo_symbol_arguments(symbol, arguments, arguments_size)
    ccall((:clingo_symbol_arguments, libclingo), Bool, (clingo_symbol_t, Ptr{Ptr{clingo_symbol_t}}, Ptr{Csize_t}), symbol, arguments, arguments_size)
end

function clingo_symbol_type(symbol)
    ccall((:clingo_symbol_type, libclingo), clingo_symbol_type_t, (clingo_symbol_t,), symbol)
end

function clingo_symbol_to_string_size(symbol, size)
    ccall((:clingo_symbol_to_string_size, libclingo), Bool, (clingo_symbol_t, Ptr{Csize_t}), symbol, size)
end

function clingo_symbol_to_string(symbol, string, size)
    ccall((:clingo_symbol_to_string, libclingo), Bool, (clingo_symbol_t, Ptr{Cchar}, Csize_t), symbol, string, size)
end

function clingo_symbol_is_equal_to(a, b)
    ccall((:clingo_symbol_is_equal_to, libclingo), Bool, (clingo_symbol_t, clingo_symbol_t), a, b)
end

function clingo_symbol_is_less_than(a, b)
    ccall((:clingo_symbol_is_less_than, libclingo), Bool, (clingo_symbol_t, clingo_symbol_t), a, b)
end

function clingo_symbol_hash(symbol)
    ccall((:clingo_symbol_hash, libclingo), Csize_t, (clingo_symbol_t,), symbol)
end

function clingo_add_string(string, result)
    ccall((:clingo_add_string, libclingo), Bool, (Ptr{Cchar}, Ptr{Ptr{Cchar}}), string, result)
end

function clingo_parse_term(string, logger, logger_data, message_limit, symbol)
    ccall((:clingo_parse_term, libclingo), Bool, (Ptr{Cchar}, clingo_logger_t, Ptr{Cvoid}, Cuint, Ptr{clingo_symbol_t}), string, logger, logger_data, message_limit, symbol)
end

mutable struct clingo_symbolic_atoms end

const clingo_symbolic_atoms_t = clingo_symbolic_atoms

const clingo_symbolic_atom_iterator_t = UInt64

function clingo_symbolic_atoms_size(atoms, size)
    ccall((:clingo_symbolic_atoms_size, libclingo), Bool, (Ptr{clingo_symbolic_atoms_t}, Ptr{Csize_t}), atoms, size)
end

function clingo_symbolic_atoms_begin(atoms, signature, iterator)
    ccall((:clingo_symbolic_atoms_begin, libclingo), Bool, (Ptr{clingo_symbolic_atoms_t}, Ptr{clingo_signature_t}, Ptr{clingo_symbolic_atom_iterator_t}), atoms, signature, iterator)
end

function clingo_symbolic_atoms_end(atoms, iterator)
    ccall((:clingo_symbolic_atoms_end, libclingo), Bool, (Ptr{clingo_symbolic_atoms_t}, Ptr{clingo_symbolic_atom_iterator_t}), atoms, iterator)
end

function clingo_symbolic_atoms_find(atoms, symbol, iterator)
    ccall((:clingo_symbolic_atoms_find, libclingo), Bool, (Ptr{clingo_symbolic_atoms_t}, clingo_symbol_t, Ptr{clingo_symbolic_atom_iterator_t}), atoms, symbol, iterator)
end

function clingo_symbolic_atoms_iterator_is_equal_to(atoms, a, b, equal)
    ccall((:clingo_symbolic_atoms_iterator_is_equal_to, libclingo), Bool, (Ptr{clingo_symbolic_atoms_t}, clingo_symbolic_atom_iterator_t, clingo_symbolic_atom_iterator_t, Ptr{Bool}), atoms, a, b, equal)
end

function clingo_symbolic_atoms_symbol(atoms, iterator, symbol)
    ccall((:clingo_symbolic_atoms_symbol, libclingo), Bool, (Ptr{clingo_symbolic_atoms_t}, clingo_symbolic_atom_iterator_t, Ptr{clingo_symbol_t}), atoms, iterator, symbol)
end

function clingo_symbolic_atoms_is_fact(atoms, iterator, fact)
    ccall((:clingo_symbolic_atoms_is_fact, libclingo), Bool, (Ptr{clingo_symbolic_atoms_t}, clingo_symbolic_atom_iterator_t, Ptr{Bool}), atoms, iterator, fact)
end

function clingo_symbolic_atoms_is_external(atoms, iterator, external)
    ccall((:clingo_symbolic_atoms_is_external, libclingo), Bool, (Ptr{clingo_symbolic_atoms_t}, clingo_symbolic_atom_iterator_t, Ptr{Bool}), atoms, iterator, external)
end

function clingo_symbolic_atoms_literal(atoms, iterator, literal)
    ccall((:clingo_symbolic_atoms_literal, libclingo), Bool, (Ptr{clingo_symbolic_atoms_t}, clingo_symbolic_atom_iterator_t, Ptr{clingo_literal_t}), atoms, iterator, literal)
end

function clingo_symbolic_atoms_signatures_size(atoms, size)
    ccall((:clingo_symbolic_atoms_signatures_size, libclingo), Bool, (Ptr{clingo_symbolic_atoms_t}, Ptr{Csize_t}), atoms, size)
end

function clingo_symbolic_atoms_signatures(atoms, signatures, size)
    ccall((:clingo_symbolic_atoms_signatures, libclingo), Bool, (Ptr{clingo_symbolic_atoms_t}, Ptr{clingo_signature_t}, Csize_t), atoms, signatures, size)
end

function clingo_symbolic_atoms_next(atoms, iterator, next)
    ccall((:clingo_symbolic_atoms_next, libclingo), Bool, (Ptr{clingo_symbolic_atoms_t}, clingo_symbolic_atom_iterator_t, Ptr{clingo_symbolic_atom_iterator_t}), atoms, iterator, next)
end

function clingo_symbolic_atoms_is_valid(atoms, iterator, valid)
    ccall((:clingo_symbolic_atoms_is_valid, libclingo), Bool, (Ptr{clingo_symbolic_atoms_t}, clingo_symbolic_atom_iterator_t, Ptr{Bool}), atoms, iterator, valid)
end

# typedef bool ( * clingo_symbol_callback_t ) ( clingo_symbol_t const * symbols , size_t symbols_size , void * data )
const clingo_symbol_callback_t = Ptr{Cvoid}

@enum clingo_theory_term_type_e::UInt32 begin
    clingo_theory_term_type_tuple = 0
    clingo_theory_term_type_list = 1
    clingo_theory_term_type_set = 2
    clingo_theory_term_type_function = 3
    clingo_theory_term_type_number = 4
    clingo_theory_term_type_symbol = 5
end

const clingo_theory_term_type_t = Cint

mutable struct clingo_theory_atoms end

const clingo_theory_atoms_t = clingo_theory_atoms

function clingo_theory_atoms_term_type(atoms, term, type)
    ccall((:clingo_theory_atoms_term_type, libclingo), Bool, (Ptr{clingo_theory_atoms_t}, clingo_id_t, Ptr{clingo_theory_term_type_t}), atoms, term, type)
end

function clingo_theory_atoms_term_number(atoms, term, number)
    ccall((:clingo_theory_atoms_term_number, libclingo), Bool, (Ptr{clingo_theory_atoms_t}, clingo_id_t, Ptr{Cint}), atoms, term, number)
end

function clingo_theory_atoms_term_name(atoms, term, name)
    ccall((:clingo_theory_atoms_term_name, libclingo), Bool, (Ptr{clingo_theory_atoms_t}, clingo_id_t, Ptr{Ptr{Cchar}}), atoms, term, name)
end

function clingo_theory_atoms_term_arguments(atoms, term, arguments, size)
    ccall((:clingo_theory_atoms_term_arguments, libclingo), Bool, (Ptr{clingo_theory_atoms_t}, clingo_id_t, Ptr{Ptr{clingo_id_t}}, Ptr{Csize_t}), atoms, term, arguments, size)
end

function clingo_theory_atoms_term_to_string_size(atoms, term, size)
    ccall((:clingo_theory_atoms_term_to_string_size, libclingo), Bool, (Ptr{clingo_theory_atoms_t}, clingo_id_t, Ptr{Csize_t}), atoms, term, size)
end

function clingo_theory_atoms_term_to_string(atoms, term, string, size)
    ccall((:clingo_theory_atoms_term_to_string, libclingo), Bool, (Ptr{clingo_theory_atoms_t}, clingo_id_t, Ptr{Cchar}, Csize_t), atoms, term, string, size)
end

function clingo_theory_atoms_element_tuple(atoms, element, tuple, size)
    ccall((:clingo_theory_atoms_element_tuple, libclingo), Bool, (Ptr{clingo_theory_atoms_t}, clingo_id_t, Ptr{Ptr{clingo_id_t}}, Ptr{Csize_t}), atoms, element, tuple, size)
end

function clingo_theory_atoms_element_condition(atoms, element, condition, size)
    ccall((:clingo_theory_atoms_element_condition, libclingo), Bool, (Ptr{clingo_theory_atoms_t}, clingo_id_t, Ptr{Ptr{clingo_literal_t}}, Ptr{Csize_t}), atoms, element, condition, size)
end

function clingo_theory_atoms_element_condition_id(atoms, element, condition)
    ccall((:clingo_theory_atoms_element_condition_id, libclingo), Bool, (Ptr{clingo_theory_atoms_t}, clingo_id_t, Ptr{clingo_literal_t}), atoms, element, condition)
end

function clingo_theory_atoms_element_to_string_size(atoms, element, size)
    ccall((:clingo_theory_atoms_element_to_string_size, libclingo), Bool, (Ptr{clingo_theory_atoms_t}, clingo_id_t, Ptr{Csize_t}), atoms, element, size)
end

function clingo_theory_atoms_element_to_string(atoms, element, string, size)
    ccall((:clingo_theory_atoms_element_to_string, libclingo), Bool, (Ptr{clingo_theory_atoms_t}, clingo_id_t, Ptr{Cchar}, Csize_t), atoms, element, string, size)
end

function clingo_theory_atoms_size(atoms, size)
    ccall((:clingo_theory_atoms_size, libclingo), Bool, (Ptr{clingo_theory_atoms_t}, Ptr{Csize_t}), atoms, size)
end

function clingo_theory_atoms_atom_term(atoms, atom, term)
    ccall((:clingo_theory_atoms_atom_term, libclingo), Bool, (Ptr{clingo_theory_atoms_t}, clingo_id_t, Ptr{clingo_id_t}), atoms, atom, term)
end

function clingo_theory_atoms_atom_elements(atoms, atom, elements, size)
    ccall((:clingo_theory_atoms_atom_elements, libclingo), Bool, (Ptr{clingo_theory_atoms_t}, clingo_id_t, Ptr{Ptr{clingo_id_t}}, Ptr{Csize_t}), atoms, atom, elements, size)
end

function clingo_theory_atoms_atom_has_guard(atoms, atom, has_guard)
    ccall((:clingo_theory_atoms_atom_has_guard, libclingo), Bool, (Ptr{clingo_theory_atoms_t}, clingo_id_t, Ptr{Bool}), atoms, atom, has_guard)
end

function clingo_theory_atoms_atom_guard(atoms, atom, connective, term)
    ccall((:clingo_theory_atoms_atom_guard, libclingo), Bool, (Ptr{clingo_theory_atoms_t}, clingo_id_t, Ptr{Ptr{Cchar}}, Ptr{clingo_id_t}), atoms, atom, connective, term)
end

function clingo_theory_atoms_atom_literal(atoms, atom, literal)
    ccall((:clingo_theory_atoms_atom_literal, libclingo), Bool, (Ptr{clingo_theory_atoms_t}, clingo_id_t, Ptr{clingo_literal_t}), atoms, atom, literal)
end

function clingo_theory_atoms_atom_to_string_size(atoms, atom, size)
    ccall((:clingo_theory_atoms_atom_to_string_size, libclingo), Bool, (Ptr{clingo_theory_atoms_t}, clingo_id_t, Ptr{Csize_t}), atoms, atom, size)
end

function clingo_theory_atoms_atom_to_string(atoms, atom, string, size)
    ccall((:clingo_theory_atoms_atom_to_string, libclingo), Bool, (Ptr{clingo_theory_atoms_t}, clingo_id_t, Ptr{Cchar}, Csize_t), atoms, atom, string, size)
end

mutable struct clingo_assignment end

const clingo_assignment_t = clingo_assignment

function clingo_assignment_decision_level(assignment)
    ccall((:clingo_assignment_decision_level, libclingo), UInt32, (Ptr{clingo_assignment_t},), assignment)
end

function clingo_assignment_root_level(assignment)
    ccall((:clingo_assignment_root_level, libclingo), UInt32, (Ptr{clingo_assignment_t},), assignment)
end

function clingo_assignment_has_conflict(assignment)
    ccall((:clingo_assignment_has_conflict, libclingo), Bool, (Ptr{clingo_assignment_t},), assignment)
end

function clingo_assignment_has_literal(assignment, literal)
    ccall((:clingo_assignment_has_literal, libclingo), Bool, (Ptr{clingo_assignment_t}, clingo_literal_t), assignment, literal)
end

function clingo_assignment_level(assignment, literal, level)
    ccall((:clingo_assignment_level, libclingo), Bool, (Ptr{clingo_assignment_t}, clingo_literal_t, Ptr{UInt32}), assignment, literal, level)
end

function clingo_assignment_decision(assignment, level, literal)
    ccall((:clingo_assignment_decision, libclingo), Bool, (Ptr{clingo_assignment_t}, UInt32, Ptr{clingo_literal_t}), assignment, level, literal)
end

function clingo_assignment_is_fixed(assignment, literal, is_fixed)
    ccall((:clingo_assignment_is_fixed, libclingo), Bool, (Ptr{clingo_assignment_t}, clingo_literal_t, Ptr{Bool}), assignment, literal, is_fixed)
end

function clingo_assignment_is_true(assignment, literal, is_true)
    ccall((:clingo_assignment_is_true, libclingo), Bool, (Ptr{clingo_assignment_t}, clingo_literal_t, Ptr{Bool}), assignment, literal, is_true)
end

function clingo_assignment_is_false(assignment, literal, is_false)
    ccall((:clingo_assignment_is_false, libclingo), Bool, (Ptr{clingo_assignment_t}, clingo_literal_t, Ptr{Bool}), assignment, literal, is_false)
end

function clingo_assignment_truth_value(assignment, literal, value)
    ccall((:clingo_assignment_truth_value, libclingo), Bool, (Ptr{clingo_assignment_t}, clingo_literal_t, Ptr{clingo_truth_value_t}), assignment, literal, value)
end

function clingo_assignment_size(assignment)
    ccall((:clingo_assignment_size, libclingo), Csize_t, (Ptr{clingo_assignment_t},), assignment)
end

function clingo_assignment_at(assignment, offset, literal)
    ccall((:clingo_assignment_at, libclingo), Bool, (Ptr{clingo_assignment_t}, Csize_t, Ptr{clingo_literal_t}), assignment, offset, literal)
end

function clingo_assignment_is_total(assignment)
    ccall((:clingo_assignment_is_total, libclingo), Bool, (Ptr{clingo_assignment_t},), assignment)
end

function clingo_assignment_trail_size(assignment, size)
    ccall((:clingo_assignment_trail_size, libclingo), Bool, (Ptr{clingo_assignment_t}, Ptr{UInt32}), assignment, size)
end

function clingo_assignment_trail_begin(assignment, level, offset)
    ccall((:clingo_assignment_trail_begin, libclingo), Bool, (Ptr{clingo_assignment_t}, UInt32, Ptr{UInt32}), assignment, level, offset)
end

function clingo_assignment_trail_end(assignment, level, offset)
    ccall((:clingo_assignment_trail_end, libclingo), Bool, (Ptr{clingo_assignment_t}, UInt32, Ptr{UInt32}), assignment, level, offset)
end

function clingo_assignment_trail_at(assignment, offset, literal)
    ccall((:clingo_assignment_trail_at, libclingo), Bool, (Ptr{clingo_assignment_t}, UInt32, Ptr{clingo_literal_t}), assignment, offset, literal)
end

@enum clingo_propagator_check_mode_e::UInt32 begin
    clingo_propagator_check_mode_none = 0
    clingo_propagator_check_mode_total = 1
    clingo_propagator_check_mode_fixpoint = 2
    clingo_propagator_check_mode_both = 3
end

const clingo_propagator_check_mode_t = Cint

@enum clingo_weight_constraint_type_e::Int32 begin
    clingo_weight_constraint_type_implication_left = -1
    clingo_weight_constraint_type_implication_right = 1
    clingo_weight_constraint_type_equivalence = 0
end

const clingo_weight_constraint_type_t = Cint

mutable struct clingo_propagate_init end

const clingo_propagate_init_t = clingo_propagate_init

function clingo_propagate_init_solver_literal(init, aspif_literal, solver_literal)
    ccall((:clingo_propagate_init_solver_literal, libclingo), Bool, (Ptr{clingo_propagate_init_t}, clingo_literal_t, Ptr{clingo_literal_t}), init, aspif_literal, solver_literal)
end

function clingo_propagate_init_add_watch(init, solver_literal)
    ccall((:clingo_propagate_init_add_watch, libclingo), Bool, (Ptr{clingo_propagate_init_t}, clingo_literal_t), init, solver_literal)
end

function clingo_propagate_init_add_watch_to_thread(init, solver_literal, thread_id)
    ccall((:clingo_propagate_init_add_watch_to_thread, libclingo), Bool, (Ptr{clingo_propagate_init_t}, clingo_literal_t, clingo_id_t), init, solver_literal, thread_id)
end

function clingo_propagate_init_remove_watch(init, solver_literal)
    ccall((:clingo_propagate_init_remove_watch, libclingo), Bool, (Ptr{clingo_propagate_init_t}, clingo_literal_t), init, solver_literal)
end

function clingo_propagate_init_remove_watch_from_thread(init, solver_literal, thread_id)
    ccall((:clingo_propagate_init_remove_watch_from_thread, libclingo), Bool, (Ptr{clingo_propagate_init_t}, clingo_literal_t, UInt32), init, solver_literal, thread_id)
end

function clingo_propagate_init_freeze_literal(init, solver_literal)
    ccall((:clingo_propagate_init_freeze_literal, libclingo), Bool, (Ptr{clingo_propagate_init_t}, clingo_literal_t), init, solver_literal)
end

function clingo_propagate_init_symbolic_atoms(init, atoms)
    ccall((:clingo_propagate_init_symbolic_atoms, libclingo), Bool, (Ptr{clingo_propagate_init_t}, Ptr{Ptr{clingo_symbolic_atoms_t}}), init, atoms)
end

function clingo_propagate_init_theory_atoms(init, atoms)
    ccall((:clingo_propagate_init_theory_atoms, libclingo), Bool, (Ptr{clingo_propagate_init_t}, Ptr{Ptr{clingo_theory_atoms_t}}), init, atoms)
end

function clingo_propagate_init_number_of_threads(init)
    ccall((:clingo_propagate_init_number_of_threads, libclingo), Cint, (Ptr{clingo_propagate_init_t},), init)
end

function clingo_propagate_init_set_check_mode(init, mode)
    ccall((:clingo_propagate_init_set_check_mode, libclingo), Cvoid, (Ptr{clingo_propagate_init_t}, clingo_propagator_check_mode_t), init, mode)
end

function clingo_propagate_init_get_check_mode(init)
    ccall((:clingo_propagate_init_get_check_mode, libclingo), clingo_propagator_check_mode_t, (Ptr{clingo_propagate_init_t},), init)
end

function clingo_propagate_init_assignment(init)
    ccall((:clingo_propagate_init_assignment, libclingo), Ptr{clingo_assignment_t}, (Ptr{clingo_propagate_init_t},), init)
end

function clingo_propagate_init_add_literal(init, freeze, result)
    ccall((:clingo_propagate_init_add_literal, libclingo), Bool, (Ptr{clingo_propagate_init_t}, Bool, Ptr{clingo_literal_t}), init, freeze, result)
end

function clingo_propagate_init_add_clause(init, clause, size, result)
    ccall((:clingo_propagate_init_add_clause, libclingo), Bool, (Ptr{clingo_propagate_init_t}, Ptr{clingo_literal_t}, Csize_t, Ptr{Bool}), init, clause, size, result)
end

function clingo_propagate_init_add_weight_constraint(init, literal, literals, size, bound, type, compare_equal, result)
    ccall((:clingo_propagate_init_add_weight_constraint, libclingo), Bool, (Ptr{clingo_propagate_init_t}, clingo_literal_t, Ptr{clingo_weighted_literal_t}, Csize_t, clingo_weight_t, clingo_weight_constraint_type_t, Bool, Ptr{Bool}), init, literal, literals, size, bound, type, compare_equal, result)
end

function clingo_propagate_init_add_minimize(init, literal, weight, priority)
    ccall((:clingo_propagate_init_add_minimize, libclingo), Bool, (Ptr{clingo_propagate_init_t}, clingo_literal_t, clingo_weight_t, clingo_weight_t), init, literal, weight, priority)
end

function clingo_propagate_init_propagate(init, result)
    ccall((:clingo_propagate_init_propagate, libclingo), Bool, (Ptr{clingo_propagate_init_t}, Ptr{Bool}), init, result)
end

@enum clingo_clause_type_e::UInt32 begin
    clingo_clause_type_learnt = 0
    clingo_clause_type_static = 1
    clingo_clause_type_volatile = 2
    clingo_clause_type_volatile_static = 3
end

const clingo_clause_type_t = Cint

mutable struct clingo_propagate_control end

const clingo_propagate_control_t = clingo_propagate_control

function clingo_propagate_control_thread_id(control)
    ccall((:clingo_propagate_control_thread_id, libclingo), clingo_id_t, (Ptr{clingo_propagate_control_t},), control)
end

function clingo_propagate_control_assignment(control)
    ccall((:clingo_propagate_control_assignment, libclingo), Ptr{clingo_assignment_t}, (Ptr{clingo_propagate_control_t},), control)
end

function clingo_propagate_control_add_literal(control, result)
    ccall((:clingo_propagate_control_add_literal, libclingo), Bool, (Ptr{clingo_propagate_control_t}, Ptr{clingo_literal_t}), control, result)
end

function clingo_propagate_control_add_watch(control, literal)
    ccall((:clingo_propagate_control_add_watch, libclingo), Bool, (Ptr{clingo_propagate_control_t}, clingo_literal_t), control, literal)
end

function clingo_propagate_control_has_watch(control, literal)
    ccall((:clingo_propagate_control_has_watch, libclingo), Bool, (Ptr{clingo_propagate_control_t}, clingo_literal_t), control, literal)
end

function clingo_propagate_control_remove_watch(control, literal)
    ccall((:clingo_propagate_control_remove_watch, libclingo), Cvoid, (Ptr{clingo_propagate_control_t}, clingo_literal_t), control, literal)
end

function clingo_propagate_control_add_clause(control, clause, size, type, result)
    ccall((:clingo_propagate_control_add_clause, libclingo), Bool, (Ptr{clingo_propagate_control_t}, Ptr{clingo_literal_t}, Csize_t, clingo_clause_type_t, Ptr{Bool}), control, clause, size, type, result)
end

function clingo_propagate_control_propagate(control, result)
    ccall((:clingo_propagate_control_propagate, libclingo), Bool, (Ptr{clingo_propagate_control_t}, Ptr{Bool}), control, result)
end

# typedef bool ( * clingo_propagator_init_callback_t ) ( clingo_propagate_init_t * , void * )
const clingo_propagator_init_callback_t = Ptr{Cvoid}

# typedef bool ( * clingo_propagator_propagate_callback_t ) ( clingo_propagate_control_t * , clingo_literal_t const * , size_t , void * )
const clingo_propagator_propagate_callback_t = Ptr{Cvoid}

# typedef void ( * clingo_propagator_undo_callback_t ) ( clingo_propagate_control_t const * , clingo_literal_t const * , size_t , void * )
const clingo_propagator_undo_callback_t = Ptr{Cvoid}

# typedef bool ( * clingo_propagator_check_callback_t ) ( clingo_propagate_control_t * , void * )
const clingo_propagator_check_callback_t = Ptr{Cvoid}

struct clingo_propagator
    init::Ptr{Cvoid}
    propagate::Ptr{Cvoid}
    undo::Ptr{Cvoid}
    check::Ptr{Cvoid}
    decide::Ptr{Cvoid}
end

const clingo_propagator_t = clingo_propagator

@enum clingo_heuristic_type_e::UInt32 begin
    clingo_heuristic_type_level = 0
    clingo_heuristic_type_sign = 1
    clingo_heuristic_type_factor = 2
    clingo_heuristic_type_init = 3
    clingo_heuristic_type_true = 4
    clingo_heuristic_type_false = 5
end

const clingo_heuristic_type_t = Cint

@enum clingo_external_type_e::UInt32 begin
    clingo_external_type_free = 0
    clingo_external_type_true = 1
    clingo_external_type_false = 2
    clingo_external_type_release = 3
end

const clingo_external_type_t = Cint

mutable struct clingo_backend end

const clingo_backend_t = clingo_backend

function clingo_backend_begin(backend)
    ccall((:clingo_backend_begin, libclingo), Bool, (Ptr{clingo_backend_t},), backend)
end

function clingo_backend_end(backend)
    ccall((:clingo_backend_end, libclingo), Bool, (Ptr{clingo_backend_t},), backend)
end

function clingo_backend_rule(backend, choice, head, head_size, body, body_size)
    ccall((:clingo_backend_rule, libclingo), Bool, (Ptr{clingo_backend_t}, Bool, Ptr{clingo_atom_t}, Csize_t, Ptr{clingo_literal_t}, Csize_t), backend, choice, head, head_size, body, body_size)
end

function clingo_backend_weight_rule(backend, choice, head, head_size, lower_bound, body, body_size)
    ccall((:clingo_backend_weight_rule, libclingo), Bool, (Ptr{clingo_backend_t}, Bool, Ptr{clingo_atom_t}, Csize_t, clingo_weight_t, Ptr{clingo_weighted_literal_t}, Csize_t), backend, choice, head, head_size, lower_bound, body, body_size)
end

function clingo_backend_minimize(backend, priority, literals, size)
    ccall((:clingo_backend_minimize, libclingo), Bool, (Ptr{clingo_backend_t}, clingo_weight_t, Ptr{clingo_weighted_literal_t}, Csize_t), backend, priority, literals, size)
end

function clingo_backend_project(backend, atoms, size)
    ccall((:clingo_backend_project, libclingo), Bool, (Ptr{clingo_backend_t}, Ptr{clingo_atom_t}, Csize_t), backend, atoms, size)
end

function clingo_backend_external(backend, atom, type)
    ccall((:clingo_backend_external, libclingo), Bool, (Ptr{clingo_backend_t}, clingo_atom_t, clingo_external_type_t), backend, atom, type)
end

function clingo_backend_assume(backend, literals, size)
    ccall((:clingo_backend_assume, libclingo), Bool, (Ptr{clingo_backend_t}, Ptr{clingo_literal_t}, Csize_t), backend, literals, size)
end

function clingo_backend_heuristic(backend, atom, type, bias, priority, condition, size)
    ccall((:clingo_backend_heuristic, libclingo), Bool, (Ptr{clingo_backend_t}, clingo_atom_t, clingo_heuristic_type_t, Cint, Cuint, Ptr{clingo_literal_t}, Csize_t), backend, atom, type, bias, priority, condition, size)
end

function clingo_backend_acyc_edge(backend, node_u, node_v, condition, size)
    ccall((:clingo_backend_acyc_edge, libclingo), Bool, (Ptr{clingo_backend_t}, Cint, Cint, Ptr{clingo_literal_t}, Csize_t), backend, node_u, node_v, condition, size)
end

function clingo_backend_add_atom(backend, symbol, atom)
    ccall((:clingo_backend_add_atom, libclingo), Bool, (Ptr{clingo_backend_t}, Ptr{clingo_symbol_t}, Ptr{clingo_atom_t}), backend, symbol, atom)
end

@enum clingo_configuration_type_e::UInt32 begin
    clingo_configuration_type_value = 1
    clingo_configuration_type_array = 2
    clingo_configuration_type_map = 4
end

const clingo_configuration_type_bitset_t = Cuint

mutable struct clingo_configuration end

const clingo_configuration_t = clingo_configuration

function clingo_configuration_root(configuration, key)
    ccall((:clingo_configuration_root, libclingo), Bool, (Ptr{clingo_configuration_t}, Ptr{clingo_id_t}), configuration, key)
end

function clingo_configuration_type(configuration, key, type)
    ccall((:clingo_configuration_type, libclingo), Bool, (Ptr{clingo_configuration_t}, clingo_id_t, Ptr{clingo_configuration_type_bitset_t}), configuration, key, type)
end

function clingo_configuration_description(configuration, key, description)
    ccall((:clingo_configuration_description, libclingo), Bool, (Ptr{clingo_configuration_t}, clingo_id_t, Ptr{Ptr{Cchar}}), configuration, key, description)
end

function clingo_configuration_array_size(configuration, key, size)
    ccall((:clingo_configuration_array_size, libclingo), Bool, (Ptr{clingo_configuration_t}, clingo_id_t, Ptr{Csize_t}), configuration, key, size)
end

function clingo_configuration_array_at(configuration, key, offset, subkey)
    ccall((:clingo_configuration_array_at, libclingo), Bool, (Ptr{clingo_configuration_t}, clingo_id_t, Csize_t, Ptr{clingo_id_t}), configuration, key, offset, subkey)
end

function clingo_configuration_map_size(configuration, key, size)
    ccall((:clingo_configuration_map_size, libclingo), Bool, (Ptr{clingo_configuration_t}, clingo_id_t, Ptr{Csize_t}), configuration, key, size)
end

function clingo_configuration_map_has_subkey(configuration, key, name, result)
    ccall((:clingo_configuration_map_has_subkey, libclingo), Bool, (Ptr{clingo_configuration_t}, clingo_id_t, Ptr{Cchar}, Ptr{Bool}), configuration, key, name, result)
end

function clingo_configuration_map_subkey_name(configuration, key, offset, name)
    ccall((:clingo_configuration_map_subkey_name, libclingo), Bool, (Ptr{clingo_configuration_t}, clingo_id_t, Csize_t, Ptr{Ptr{Cchar}}), configuration, key, offset, name)
end

function clingo_configuration_map_at(configuration, key, name, subkey)
    ccall((:clingo_configuration_map_at, libclingo), Bool, (Ptr{clingo_configuration_t}, clingo_id_t, Ptr{Cchar}, Ptr{clingo_id_t}), configuration, key, name, subkey)
end

function clingo_configuration_value_is_assigned(configuration, key, assigned)
    ccall((:clingo_configuration_value_is_assigned, libclingo), Bool, (Ptr{clingo_configuration_t}, clingo_id_t, Ptr{Bool}), configuration, key, assigned)
end

function clingo_configuration_value_get_size(configuration, key, size)
    ccall((:clingo_configuration_value_get_size, libclingo), Bool, (Ptr{clingo_configuration_t}, clingo_id_t, Ptr{Csize_t}), configuration, key, size)
end

function clingo_configuration_value_get(configuration, key, value, size)
    ccall((:clingo_configuration_value_get, libclingo), Bool, (Ptr{clingo_configuration_t}, clingo_id_t, Ptr{Cchar}, Csize_t), configuration, key, value, size)
end

function clingo_configuration_value_set(configuration, key, value)
    ccall((:clingo_configuration_value_set, libclingo), Bool, (Ptr{clingo_configuration_t}, clingo_id_t, Ptr{Cchar}), configuration, key, value)
end

@enum clingo_statistics_type_e::UInt32 begin
    clingo_statistics_type_empty = 0
    clingo_statistics_type_value = 1
    clingo_statistics_type_array = 2
    clingo_statistics_type_map = 3
end

const clingo_statistics_type_t = Cint

mutable struct clingo_statistic end

const clingo_statistics_t = clingo_statistic

function clingo_statistics_root(statistics, key)
    ccall((:clingo_statistics_root, libclingo), Bool, (Ptr{clingo_statistics_t}, Ptr{UInt64}), statistics, key)
end

function clingo_statistics_type(statistics, key, type)
    ccall((:clingo_statistics_type, libclingo), Bool, (Ptr{clingo_statistics_t}, UInt64, Ptr{clingo_statistics_type_t}), statistics, key, type)
end

function clingo_statistics_array_size(statistics, key, size)
    ccall((:clingo_statistics_array_size, libclingo), Bool, (Ptr{clingo_statistics_t}, UInt64, Ptr{Csize_t}), statistics, key, size)
end

function clingo_statistics_array_at(statistics, key, offset, subkey)
    ccall((:clingo_statistics_array_at, libclingo), Bool, (Ptr{clingo_statistics_t}, UInt64, Csize_t, Ptr{UInt64}), statistics, key, offset, subkey)
end

function clingo_statistics_array_push(statistics, key, type, subkey)
    ccall((:clingo_statistics_array_push, libclingo), Bool, (Ptr{clingo_statistics_t}, UInt64, clingo_statistics_type_t, Ptr{UInt64}), statistics, key, type, subkey)
end

function clingo_statistics_map_size(statistics, key, size)
    ccall((:clingo_statistics_map_size, libclingo), Bool, (Ptr{clingo_statistics_t}, UInt64, Ptr{Csize_t}), statistics, key, size)
end

function clingo_statistics_map_has_subkey(statistics, key, name, result)
    ccall((:clingo_statistics_map_has_subkey, libclingo), Bool, (Ptr{clingo_statistics_t}, UInt64, Ptr{Cchar}, Ptr{Bool}), statistics, key, name, result)
end

function clingo_statistics_map_subkey_name(statistics, key, offset, name)
    ccall((:clingo_statistics_map_subkey_name, libclingo), Bool, (Ptr{clingo_statistics_t}, UInt64, Csize_t, Ptr{Ptr{Cchar}}), statistics, key, offset, name)
end

function clingo_statistics_map_at(statistics, key, name, subkey)
    ccall((:clingo_statistics_map_at, libclingo), Bool, (Ptr{clingo_statistics_t}, UInt64, Ptr{Cchar}, Ptr{UInt64}), statistics, key, name, subkey)
end

function clingo_statistics_map_add_subkey(statistics, key, name, type, subkey)
    ccall((:clingo_statistics_map_add_subkey, libclingo), Bool, (Ptr{clingo_statistics_t}, UInt64, Ptr{Cchar}, clingo_statistics_type_t, Ptr{UInt64}), statistics, key, name, type, subkey)
end

function clingo_statistics_value_get(statistics, key, value)
    ccall((:clingo_statistics_value_get, libclingo), Bool, (Ptr{clingo_statistics_t}, UInt64, Ptr{Cdouble}), statistics, key, value)
end

function clingo_statistics_value_set(statistics, key, value)
    ccall((:clingo_statistics_value_set, libclingo), Bool, (Ptr{clingo_statistics_t}, UInt64, Cdouble), statistics, key, value)
end

mutable struct clingo_solve_control end

const clingo_solve_control_t = clingo_solve_control

mutable struct clingo_model end

const clingo_model_t = clingo_model

@enum clingo_model_type_e::UInt32 begin
    clingo_model_type_stable_model = 0
    clingo_model_type_brave_consequences = 1
    clingo_model_type_cautious_consequences = 2
end

const clingo_model_type_t = Cint

@enum clingo_show_type_e::UInt32 begin
    clingo_show_type_csp = 1
    clingo_show_type_shown = 2
    clingo_show_type_atoms = 4
    clingo_show_type_terms = 8
    clingo_show_type_theory = 16
    clingo_show_type_all = 31
    clingo_show_type_complement = 32
end

const clingo_show_type_bitset_t = Cuint

function clingo_model_type(model, type)
    ccall((:clingo_model_type, libclingo), Bool, (Ptr{clingo_model_t}, Ptr{clingo_model_type_t}), model, type)
end

function clingo_model_number(model, number)
    ccall((:clingo_model_number, libclingo), Bool, (Ptr{clingo_model_t}, Ptr{UInt64}), model, number)
end

function clingo_model_symbols_size(model, show, size)
    ccall((:clingo_model_symbols_size, libclingo), Bool, (Ptr{clingo_model_t}, clingo_show_type_bitset_t, Ptr{Csize_t}), model, show, size)
end

function clingo_model_symbols(model, show, symbols, size)
    ccall((:clingo_model_symbols, libclingo), Bool, (Ptr{clingo_model_t}, clingo_show_type_bitset_t, Ptr{clingo_symbol_t}, Csize_t), model, show, symbols, size)
end

function clingo_model_contains(model, atom, contained)
    ccall((:clingo_model_contains, libclingo), Bool, (Ptr{clingo_model_t}, clingo_symbol_t, Ptr{Bool}), model, atom, contained)
end

function clingo_model_is_true(model, literal, result)
    ccall((:clingo_model_is_true, libclingo), Bool, (Ptr{clingo_model_t}, clingo_literal_t, Ptr{Bool}), model, literal, result)
end

function clingo_model_cost_size(model, size)
    ccall((:clingo_model_cost_size, libclingo), Bool, (Ptr{clingo_model_t}, Ptr{Csize_t}), model, size)
end

function clingo_model_cost(model, costs, size)
    ccall((:clingo_model_cost, libclingo), Bool, (Ptr{clingo_model_t}, Ptr{Int64}, Csize_t), model, costs, size)
end

function clingo_model_optimality_proven(model, proven)
    ccall((:clingo_model_optimality_proven, libclingo), Bool, (Ptr{clingo_model_t}, Ptr{Bool}), model, proven)
end

function clingo_model_thread_id(model, id)
    ccall((:clingo_model_thread_id, libclingo), Bool, (Ptr{clingo_model_t}, Ptr{clingo_id_t}), model, id)
end

function clingo_model_extend(model, symbols, size)
    ccall((:clingo_model_extend, libclingo), Bool, (Ptr{clingo_model_t}, Ptr{clingo_symbol_t}, Csize_t), model, symbols, size)
end

function clingo_model_context(model, control)
    ccall((:clingo_model_context, libclingo), Bool, (Ptr{clingo_model_t}, Ptr{Ptr{clingo_solve_control_t}}), model, control)
end

function clingo_solve_control_symbolic_atoms(control, atoms)
    ccall((:clingo_solve_control_symbolic_atoms, libclingo), Bool, (Ptr{clingo_solve_control_t}, Ptr{Ptr{clingo_symbolic_atoms_t}}), control, atoms)
end

function clingo_solve_control_add_clause(control, clause, size)
    ccall((:clingo_solve_control_add_clause, libclingo), Bool, (Ptr{clingo_solve_control_t}, Ptr{clingo_literal_t}, Csize_t), control, clause, size)
end

@enum clingo_solve_result_e::UInt32 begin
    clingo_solve_result_satisfiable = 1
    clingo_solve_result_unsatisfiable = 2
    clingo_solve_result_exhausted = 4
    clingo_solve_result_interrupted = 8
end

const clingo_solve_result_bitset_t = Cuint

@enum clingo_solve_mode_e::UInt32 begin
    clingo_solve_mode_async = 1
    clingo_solve_mode_yield = 2
end

const clingo_solve_mode_bitset_t = Cuint

@enum clingo_solve_event_type_e::UInt32 begin
    clingo_solve_event_type_model = 0
    clingo_solve_event_type_unsat = 1
    clingo_solve_event_type_statistics = 2
    clingo_solve_event_type_finish = 3
end

const clingo_solve_event_type_t = Cuint

# typedef bool ( * clingo_solve_event_callback_t ) ( clingo_solve_event_type_t type , void * event , void * data , bool * goon )
const clingo_solve_event_callback_t = Ptr{Cvoid}

mutable struct clingo_solve_handle end

const clingo_solve_handle_t = clingo_solve_handle

function clingo_solve_handle_get(handle, result)
    ccall((:clingo_solve_handle_get, libclingo), Bool, (Ptr{clingo_solve_handle_t}, Ptr{clingo_solve_result_bitset_t}), handle, result)
end

function clingo_solve_handle_wait(handle, timeout, result)
    ccall((:clingo_solve_handle_wait, libclingo), Cvoid, (Ptr{clingo_solve_handle_t}, Cdouble, Ptr{Bool}), handle, timeout, result)
end

function clingo_solve_handle_model(handle, model)
    ccall((:clingo_solve_handle_model, libclingo), Bool, (Ptr{clingo_solve_handle_t}, Ptr{Ptr{clingo_model_t}}), handle, model)
end

function clingo_solve_handle_core(handle, core, size)
    ccall((:clingo_solve_handle_core, libclingo), Bool, (Ptr{clingo_solve_handle_t}, Ptr{Ptr{clingo_literal_t}}, Ptr{Csize_t}), handle, core, size)
end

function clingo_solve_handle_resume(handle)
    ccall((:clingo_solve_handle_resume, libclingo), Bool, (Ptr{clingo_solve_handle_t},), handle)
end

function clingo_solve_handle_cancel(handle)
    ccall((:clingo_solve_handle_cancel, libclingo), Bool, (Ptr{clingo_solve_handle_t},), handle)
end

function clingo_solve_handle_close(handle)
    ccall((:clingo_solve_handle_close, libclingo), Bool, (Ptr{clingo_solve_handle_t},), handle)
end

@enum clingo_ast_theory_sequence_type_e::UInt32 begin
    clingo_ast_theory_sequence_type_tuple = 0
    clingo_ast_theory_sequence_type_list = 1
    clingo_ast_theory_sequence_type_set = 2
end

const clingo_ast_theory_sequence_type_t = Cint

@enum clingo_ast_comparison_operator_e::UInt32 begin
    clingo_ast_comparison_operator_greater_than = 0
    clingo_ast_comparison_operator_less_than = 1
    clingo_ast_comparison_operator_less_equal = 2
    clingo_ast_comparison_operator_greater_equal = 3
    clingo_ast_comparison_operator_not_equal = 4
    clingo_ast_comparison_operator_equal = 5
end

const clingo_ast_comparison_operator_t = Cint

@enum clingo_ast_sign_e::UInt32 begin
    clingo_ast_sign_no_sign = 0
    clingo_ast_sign_negation = 1
    clingo_ast_sign_double_negation = 2
end

const clingo_ast_sign_t = Cint

@enum clingo_ast_unary_operator_e::UInt32 begin
    clingo_ast_unary_operator_minus = 0
    clingo_ast_unary_operator_negation = 1
    clingo_ast_unary_operator_absolute = 2
end

const clingo_ast_unary_operator_t = Cint

@enum clingo_ast_binary_operator_e::UInt32 begin
    clingo_ast_binary_operator_xor = 0
    clingo_ast_binary_operator_or = 1
    clingo_ast_binary_operator_and = 2
    clingo_ast_binary_operator_plus = 3
    clingo_ast_binary_operator_minus = 4
    clingo_ast_binary_operator_multiplication = 5
    clingo_ast_binary_operator_division = 6
    clingo_ast_binary_operator_modulo = 7
    clingo_ast_binary_operator_power = 8
end

const clingo_ast_binary_operator_t = Cint

@enum clingo_ast_aggregate_function_e::UInt32 begin
    clingo_ast_aggregate_function_count = 0
    clingo_ast_aggregate_function_sum = 1
    clingo_ast_aggregate_function_sump = 2
    clingo_ast_aggregate_function_min = 3
    clingo_ast_aggregate_function_max = 4
end

const clingo_ast_aggregate_function_t = Cint

@enum clingo_ast_theory_operator_type_e::UInt32 begin
    clingo_ast_theory_operator_type_unary = 0
    clingo_ast_theory_operator_type_binary_left = 1
    clingo_ast_theory_operator_type_binary_right = 2
end

const clingo_ast_theory_operator_type_t = Cint

@enum clingo_ast_theory_atom_definition_type_e::UInt32 begin
    clingo_ast_theory_atom_definition_type_head = 0
    clingo_ast_theory_atom_definition_type_body = 1
    clingo_ast_theory_atom_definition_type_any = 2
    clingo_ast_theory_atom_definition_type_directive = 3
end

const clingo_ast_theory_atom_definition_type_t = Cint

@enum clingo_ast_type_e::UInt32 begin
    clingo_ast_type_id = 0
    clingo_ast_type_variable = 1
    clingo_ast_type_symbolic_term = 2
    clingo_ast_type_unary_operation = 3
    clingo_ast_type_binary_operation = 4
    clingo_ast_type_interval = 5
    clingo_ast_type_function = 6
    clingo_ast_type_pool = 7
    clingo_ast_type_csp_product = 8
    clingo_ast_type_csp_sum = 9
    clingo_ast_type_csp_guard = 10
    clingo_ast_type_boolean_constant = 11
    clingo_ast_type_symbolic_atom = 12
    clingo_ast_type_comparison = 13
    clingo_ast_type_csp_literal = 14
    clingo_ast_type_aggregate_guard = 15
    clingo_ast_type_conditional_literal = 16
    clingo_ast_type_aggregate = 17
    clingo_ast_type_body_aggregate_element = 18
    clingo_ast_type_body_aggregate = 19
    clingo_ast_type_head_aggregate_element = 20
    clingo_ast_type_head_aggregate = 21
    clingo_ast_type_disjunction = 22
    clingo_ast_type_disjoint_element = 23
    clingo_ast_type_disjoint = 24
    clingo_ast_type_theory_sequence = 25
    clingo_ast_type_theory_function = 26
    clingo_ast_type_theory_unparsed_term_element = 27
    clingo_ast_type_theory_unparsed_term = 28
    clingo_ast_type_theory_guard = 29
    clingo_ast_type_theory_atom_element = 30
    clingo_ast_type_theory_atom = 31
    clingo_ast_type_literal = 32
    clingo_ast_type_theory_operator_definition = 33
    clingo_ast_type_theory_term_definition = 34
    clingo_ast_type_theory_guard_definition = 35
    clingo_ast_type_theory_atom_definition = 36
    clingo_ast_type_rule = 37
    clingo_ast_type_definition = 38
    clingo_ast_type_show_signature = 39
    clingo_ast_type_show_term = 40
    clingo_ast_type_minimize = 41
    clingo_ast_type_script = 42
    clingo_ast_type_program = 43
    clingo_ast_type_external = 44
    clingo_ast_type_edge = 45
    clingo_ast_type_heuristic = 46
    clingo_ast_type_project_atom = 47
    clingo_ast_type_project_signature = 48
    clingo_ast_type_defined = 49
    clingo_ast_type_theory_definition = 50
end

const clingo_ast_type_t = Cint

@enum clingo_ast_attribute_type_e::UInt32 begin
    clingo_ast_attribute_type_number = 0
    clingo_ast_attribute_type_symbol = 1
    clingo_ast_attribute_type_location = 2
    clingo_ast_attribute_type_string = 3
    clingo_ast_attribute_type_ast = 4
    clingo_ast_attribute_type_optional_ast = 5
    clingo_ast_attribute_type_string_array = 6
    clingo_ast_attribute_type_ast_array = 7
end

const clingo_ast_attribute_type_t = Cint

@enum clingo_ast_attribute_e::UInt32 begin
    clingo_ast_attribute_argument = 0
    clingo_ast_attribute_arguments = 1
    clingo_ast_attribute_arity = 2
    clingo_ast_attribute_atom = 3
    clingo_ast_attribute_atoms = 4
    clingo_ast_attribute_atom_type = 5
    clingo_ast_attribute_bias = 6
    clingo_ast_attribute_body = 7
    clingo_ast_attribute_code = 8
    clingo_ast_attribute_coefficient = 9
    clingo_ast_attribute_comparison = 10
    clingo_ast_attribute_condition = 11
    clingo_ast_attribute_csp = 12
    clingo_ast_attribute_elements = 13
    clingo_ast_attribute_external = 14
    clingo_ast_attribute_external_type = 15
    clingo_ast_attribute_function = 16
    clingo_ast_attribute_guard = 17
    clingo_ast_attribute_guards = 18
    clingo_ast_attribute_head = 19
    clingo_ast_attribute_is_default = 20
    clingo_ast_attribute_left = 21
    clingo_ast_attribute_left_guard = 22
    clingo_ast_attribute_literal = 23
    clingo_ast_attribute_location = 24
    clingo_ast_attribute_modifier = 25
    clingo_ast_attribute_name = 26
    clingo_ast_attribute_node_u = 27
    clingo_ast_attribute_node_v = 28
    clingo_ast_attribute_operator_name = 29
    clingo_ast_attribute_operator_type = 30
    clingo_ast_attribute_operators = 31
    clingo_ast_attribute_parameters = 32
    clingo_ast_attribute_positive = 33
    clingo_ast_attribute_priority = 34
    clingo_ast_attribute_right = 35
    clingo_ast_attribute_right_guard = 36
    clingo_ast_attribute_sequence_type = 37
    clingo_ast_attribute_sign = 38
    clingo_ast_attribute_symbol = 39
    clingo_ast_attribute_term = 40
    clingo_ast_attribute_terms = 41
    clingo_ast_attribute_value = 42
    clingo_ast_attribute_variable = 43
    clingo_ast_attribute_weight = 44
end

const clingo_ast_attribute_t = Cint

struct clingo_ast_attribute_names
    names::Ptr{Ptr{Cchar}}
    size::Csize_t
end

const clingo_ast_attribute_names_t = clingo_ast_attribute_names

struct clingo_ast_argument
    attribute::clingo_ast_attribute_t
    type::clingo_ast_attribute_type_t
end

const clingo_ast_argument_t = clingo_ast_argument

struct clingo_ast_constructor
    name::Ptr{Cchar}
    arguments::Ptr{clingo_ast_argument_t}
    size::Csize_t
end

const clingo_ast_constructor_t = clingo_ast_constructor

struct clingo_ast_constructors
    constructors::Ptr{clingo_ast_constructor_t}
    size::Csize_t
end

const clingo_ast_constructors_t = clingo_ast_constructors

mutable struct clingo_ast end

const clingo_ast_t = clingo_ast

function clingo_ast_acquire(ast)
    ccall((:clingo_ast_acquire, libclingo), Cvoid, (Ptr{clingo_ast_t},), ast)
end

function clingo_ast_release(ast)
    ccall((:clingo_ast_release, libclingo), Cvoid, (Ptr{clingo_ast_t},), ast)
end

function clingo_ast_copy(ast, copy)
    ccall((:clingo_ast_copy, libclingo), Bool, (Ptr{clingo_ast_t}, Ptr{Ptr{clingo_ast_t}}), ast, copy)
end

function clingo_ast_deep_copy(ast, copy)
    ccall((:clingo_ast_deep_copy, libclingo), Bool, (Ptr{clingo_ast_t}, Ptr{Ptr{clingo_ast_t}}), ast, copy)
end

function clingo_ast_less_than(a, b)
    ccall((:clingo_ast_less_than, libclingo), Bool, (Ptr{clingo_ast_t}, Ptr{clingo_ast_t}), a, b)
end

function clingo_ast_equal(a, b)
    ccall((:clingo_ast_equal, libclingo), Bool, (Ptr{clingo_ast_t}, Ptr{clingo_ast_t}), a, b)
end

function clingo_ast_hash(ast)
    ccall((:clingo_ast_hash, libclingo), Csize_t, (Ptr{clingo_ast_t},), ast)
end

function clingo_ast_to_string_size(ast, size)
    ccall((:clingo_ast_to_string_size, libclingo), Bool, (Ptr{clingo_ast_t}, Ptr{Csize_t}), ast, size)
end

function clingo_ast_to_string(ast, string, size)
    ccall((:clingo_ast_to_string, libclingo), Bool, (Ptr{clingo_ast_t}, Ptr{Cchar}, Csize_t), ast, string, size)
end

function clingo_ast_get_type(ast, type)
    ccall((:clingo_ast_get_type, libclingo), Bool, (Ptr{clingo_ast_t}, Ptr{clingo_ast_type_t}), ast, type)
end

function clingo_ast_has_attribute(ast, attribute, has_attribute)
    ccall((:clingo_ast_has_attribute, libclingo), Bool, (Ptr{clingo_ast_t}, clingo_ast_attribute_t, Ptr{Bool}), ast, attribute, has_attribute)
end

function clingo_ast_attribute_type(ast, attribute, type)
    ccall((:clingo_ast_attribute_type, libclingo), Bool, (Ptr{clingo_ast_t}, clingo_ast_attribute_t, Ptr{clingo_ast_attribute_type_t}), ast, attribute, type)
end

function clingo_ast_attribute_get_number(ast, attribute, value)
    ccall((:clingo_ast_attribute_get_number, libclingo), Bool, (Ptr{clingo_ast_t}, clingo_ast_attribute_t, Ptr{Cint}), ast, attribute, value)
end

function clingo_ast_attribute_set_number(ast, attribute, value)
    ccall((:clingo_ast_attribute_set_number, libclingo), Bool, (Ptr{clingo_ast_t}, clingo_ast_attribute_t, Cint), ast, attribute, value)
end

function clingo_ast_attribute_get_symbol(ast, attribute, value)
    ccall((:clingo_ast_attribute_get_symbol, libclingo), Bool, (Ptr{clingo_ast_t}, clingo_ast_attribute_t, Ptr{clingo_symbol_t}), ast, attribute, value)
end

function clingo_ast_attribute_set_symbol(ast, attribute, value)
    ccall((:clingo_ast_attribute_set_symbol, libclingo), Bool, (Ptr{clingo_ast_t}, clingo_ast_attribute_t, clingo_symbol_t), ast, attribute, value)
end

function clingo_ast_attribute_get_location(ast, attribute, value)
    ccall((:clingo_ast_attribute_get_location, libclingo), Bool, (Ptr{clingo_ast_t}, clingo_ast_attribute_t, Ptr{clingo_location_t}), ast, attribute, value)
end

function clingo_ast_attribute_set_location(ast, attribute, value)
    ccall((:clingo_ast_attribute_set_location, libclingo), Bool, (Ptr{clingo_ast_t}, clingo_ast_attribute_t, Ptr{clingo_location_t}), ast, attribute, value)
end

function clingo_ast_attribute_get_string(ast, attribute, value)
    ccall((:clingo_ast_attribute_get_string, libclingo), Bool, (Ptr{clingo_ast_t}, clingo_ast_attribute_t, Ptr{Ptr{Cchar}}), ast, attribute, value)
end

function clingo_ast_attribute_set_string(ast, attribute, value)
    ccall((:clingo_ast_attribute_set_string, libclingo), Bool, (Ptr{clingo_ast_t}, clingo_ast_attribute_t, Ptr{Cchar}), ast, attribute, value)
end

function clingo_ast_attribute_get_ast(ast, attribute, value)
    ccall((:clingo_ast_attribute_get_ast, libclingo), Bool, (Ptr{clingo_ast_t}, clingo_ast_attribute_t, Ptr{Ptr{clingo_ast_t}}), ast, attribute, value)
end

function clingo_ast_attribute_set_ast(ast, attribute, value)
    ccall((:clingo_ast_attribute_set_ast, libclingo), Bool, (Ptr{clingo_ast_t}, clingo_ast_attribute_t, Ptr{clingo_ast_t}), ast, attribute, value)
end

function clingo_ast_attribute_get_optional_ast(ast, attribute, value)
    ccall((:clingo_ast_attribute_get_optional_ast, libclingo), Bool, (Ptr{clingo_ast_t}, clingo_ast_attribute_t, Ptr{Ptr{clingo_ast_t}}), ast, attribute, value)
end

function clingo_ast_attribute_set_optional_ast(ast, attribute, value)
    ccall((:clingo_ast_attribute_set_optional_ast, libclingo), Bool, (Ptr{clingo_ast_t}, clingo_ast_attribute_t, Ptr{clingo_ast_t}), ast, attribute, value)
end

function clingo_ast_attribute_get_string_at(ast, attribute, index, value)
    ccall((:clingo_ast_attribute_get_string_at, libclingo), Bool, (Ptr{clingo_ast_t}, clingo_ast_attribute_t, Csize_t, Ptr{Ptr{Cchar}}), ast, attribute, index, value)
end

function clingo_ast_attribute_set_string_at(ast, attribute, index, value)
    ccall((:clingo_ast_attribute_set_string_at, libclingo), Bool, (Ptr{clingo_ast_t}, clingo_ast_attribute_t, Csize_t, Ptr{Cchar}), ast, attribute, index, value)
end

function clingo_ast_attribute_delete_string_at(ast, attribute, index)
    ccall((:clingo_ast_attribute_delete_string_at, libclingo), Bool, (Ptr{clingo_ast_t}, clingo_ast_attribute_t, Csize_t), ast, attribute, index)
end

function clingo_ast_attribute_size_string_array(ast, attribute, size)
    ccall((:clingo_ast_attribute_size_string_array, libclingo), Bool, (Ptr{clingo_ast_t}, clingo_ast_attribute_t, Ptr{Csize_t}), ast, attribute, size)
end

function clingo_ast_attribute_insert_string_at(ast, attribute, index, value)
    ccall((:clingo_ast_attribute_insert_string_at, libclingo), Bool, (Ptr{clingo_ast_t}, clingo_ast_attribute_t, Csize_t, Ptr{Cchar}), ast, attribute, index, value)
end

function clingo_ast_attribute_get_ast_at(ast, attribute, index, value)
    ccall((:clingo_ast_attribute_get_ast_at, libclingo), Bool, (Ptr{clingo_ast_t}, clingo_ast_attribute_t, Csize_t, Ptr{Ptr{clingo_ast_t}}), ast, attribute, index, value)
end

function clingo_ast_attribute_set_ast_at(ast, attribute, index, value)
    ccall((:clingo_ast_attribute_set_ast_at, libclingo), Bool, (Ptr{clingo_ast_t}, clingo_ast_attribute_t, Csize_t, Ptr{clingo_ast_t}), ast, attribute, index, value)
end

function clingo_ast_attribute_delete_ast_at(ast, attribute, index)
    ccall((:clingo_ast_attribute_delete_ast_at, libclingo), Bool, (Ptr{clingo_ast_t}, clingo_ast_attribute_t, Csize_t), ast, attribute, index)
end

function clingo_ast_attribute_size_ast_array(ast, attribute, size)
    ccall((:clingo_ast_attribute_size_ast_array, libclingo), Bool, (Ptr{clingo_ast_t}, clingo_ast_attribute_t, Ptr{Csize_t}), ast, attribute, size)
end

function clingo_ast_attribute_insert_ast_at(ast, attribute, index, value)
    ccall((:clingo_ast_attribute_insert_ast_at, libclingo), Bool, (Ptr{clingo_ast_t}, clingo_ast_attribute_t, Csize_t, Ptr{clingo_ast_t}), ast, attribute, index, value)
end

# typedef bool ( * clingo_ast_callback_t ) ( clingo_ast_t * ast , void * data )
const clingo_ast_callback_t = Ptr{Cvoid}

function clingo_ast_parse_string(program, callback, callback_data, logger, logger_data, message_limit)
    ccall((:clingo_ast_parse_string, libclingo), Bool, (Ptr{Cchar}, clingo_ast_callback_t, Ptr{Cvoid}, clingo_logger_t, Ptr{Cvoid}, Cuint), program, callback, callback_data, logger, logger_data, message_limit)
end

function clingo_ast_parse_files(files, size, callback, callback_data, logger, logger_data, message_limit)
    ccall((:clingo_ast_parse_files, libclingo), Bool, (Ptr{Ptr{Cchar}}, Csize_t, clingo_ast_callback_t, Ptr{Cvoid}, clingo_logger_t, Ptr{Cvoid}, Cuint), files, size, callback, callback_data, logger, logger_data, message_limit)
end

mutable struct clingo_program_builder end

const clingo_program_builder_t = clingo_program_builder

function clingo_program_builder_begin(builder)
    ccall((:clingo_program_builder_begin, libclingo), Bool, (Ptr{clingo_program_builder_t},), builder)
end

function clingo_program_builder_end(builder)
    ccall((:clingo_program_builder_end, libclingo), Bool, (Ptr{clingo_program_builder_t},), builder)
end

function clingo_program_builder_add(builder, ast)
    ccall((:clingo_program_builder_add, libclingo), Bool, (Ptr{clingo_program_builder_t}, Ptr{clingo_ast_t}), builder, ast)
end

@enum clingo_ast_unpool_type_e::UInt32 begin
    clingo_ast_unpool_type_condition = 1
    clingo_ast_unpool_type_other = 2
    clingo_ast_unpool_type_all = 3
end

const clingo_ast_unpool_type_bitset_t = Cint

function clingo_ast_unpool(ast, unpool_type, callback, callback_data)
    ccall((:clingo_ast_unpool, libclingo), Bool, (Ptr{clingo_ast_t}, clingo_ast_unpool_type_bitset_t, clingo_ast_callback_t, Ptr{Cvoid}), ast, unpool_type, callback, callback_data)
end

struct clingo_ground_program_observer
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

const clingo_ground_program_observer_t = clingo_ground_program_observer

struct clingo_part
    name::Ptr{Cchar}
    params::Ptr{clingo_symbol_t}
    size::Csize_t
end

const clingo_part_t = clingo_part

# typedef bool ( * clingo_ground_callback_t ) ( clingo_location_t const * location , char const * name , clingo_symbol_t const * arguments , size_t arguments_size , void * data , clingo_symbol_callback_t symbol_callback , void * symbol_callback_data )
const clingo_ground_callback_t = Ptr{Cvoid}

mutable struct clingo_control end

const clingo_control_t = clingo_control

function clingo_control_new(arguments, arguments_size, logger, logger_data, message_limit, control)
    ccall((:clingo_control_new, libclingo), Bool, (Ptr{Ptr{Cchar}}, Csize_t, clingo_logger_t, Ptr{Cvoid}, Cuint, Ptr{Ptr{clingo_control_t}}), arguments, arguments_size, logger, logger_data, message_limit, control)
end

function clingo_control_free(control)
    ccall((:clingo_control_free, libclingo), Cvoid, (Ptr{clingo_control_t},), control)
end

function clingo_control_load(control, file)
    ccall((:clingo_control_load, libclingo), Bool, (Ptr{clingo_control_t}, Ptr{Cchar}), control, file)
end

function clingo_control_add(control, name, parameters, parameters_size, program)
    ccall((:clingo_control_add, libclingo), Bool, (Ptr{clingo_control_t}, Ptr{Cchar}, Ptr{Ptr{Cchar}}, Csize_t, Ptr{Cchar}), control, name, parameters, parameters_size, program)
end

function clingo_control_ground(control, parts, parts_size, ground_callback, ground_callback_data)
    ccall((:clingo_control_ground, libclingo), Bool, (Ptr{clingo_control_t}, Ptr{clingo_part_t}, Csize_t, clingo_ground_callback_t, Ptr{Cvoid}), control, parts, parts_size, ground_callback, ground_callback_data)
end

function clingo_control_solve(control, mode, assumptions, assumptions_size, notify, data, handle)
    ccall((:clingo_control_solve, libclingo), Bool, (Ptr{clingo_control_t}, clingo_solve_mode_bitset_t, Ptr{clingo_literal_t}, Csize_t, clingo_solve_event_callback_t, Ptr{Cvoid}, Ptr{Ptr{clingo_solve_handle_t}}), control, mode, assumptions, assumptions_size, notify, data, handle)
end

function clingo_control_cleanup(control)
    ccall((:clingo_control_cleanup, libclingo), Bool, (Ptr{clingo_control_t},), control)
end

function clingo_control_assign_external(control, literal, value)
    ccall((:clingo_control_assign_external, libclingo), Bool, (Ptr{clingo_control_t}, clingo_literal_t, clingo_truth_value_t), control, literal, value)
end

function clingo_control_release_external(control, literal)
    ccall((:clingo_control_release_external, libclingo), Bool, (Ptr{clingo_control_t}, clingo_literal_t), control, literal)
end

function clingo_control_register_propagator(control, propagator, data, sequential)
    ccall((:clingo_control_register_propagator, libclingo), Bool, (Ptr{clingo_control_t}, Ptr{clingo_propagator_t}, Ptr{Cvoid}, Bool), control, propagator, data, sequential)
end

function clingo_control_is_conflicting(control)
    ccall((:clingo_control_is_conflicting, libclingo), Bool, (Ptr{clingo_control_t},), control)
end

function clingo_control_statistics(control, statistics)
    ccall((:clingo_control_statistics, libclingo), Bool, (Ptr{clingo_control_t}, Ptr{Ptr{clingo_statistics_t}}), control, statistics)
end

function clingo_control_interrupt(control)
    ccall((:clingo_control_interrupt, libclingo), Cvoid, (Ptr{clingo_control_t},), control)
end

function clingo_control_clasp_facade(control, clasp)
    ccall((:clingo_control_clasp_facade, libclingo), Bool, (Ptr{clingo_control_t}, Ptr{Ptr{Cvoid}}), control, clasp)
end

function clingo_control_configuration(control, configuration)
    ccall((:clingo_control_configuration, libclingo), Bool, (Ptr{clingo_control_t}, Ptr{Ptr{clingo_configuration_t}}), control, configuration)
end

function clingo_control_set_enable_enumeration_assumption(control, enable)
    ccall((:clingo_control_set_enable_enumeration_assumption, libclingo), Bool, (Ptr{clingo_control_t}, Bool), control, enable)
end

function clingo_control_get_enable_enumeration_assumption(control)
    ccall((:clingo_control_get_enable_enumeration_assumption, libclingo), Bool, (Ptr{clingo_control_t},), control)
end

function clingo_control_set_enable_cleanup(control, enable)
    ccall((:clingo_control_set_enable_cleanup, libclingo), Bool, (Ptr{clingo_control_t}, Bool), control, enable)
end

function clingo_control_get_enable_cleanup(control)
    ccall((:clingo_control_get_enable_cleanup, libclingo), Bool, (Ptr{clingo_control_t},), control)
end

function clingo_control_get_const(control, name, symbol)
    ccall((:clingo_control_get_const, libclingo), Bool, (Ptr{clingo_control_t}, Ptr{Cchar}, Ptr{clingo_symbol_t}), control, name, symbol)
end

function clingo_control_has_const(control, name, exists)
    ccall((:clingo_control_has_const, libclingo), Bool, (Ptr{clingo_control_t}, Ptr{Cchar}, Ptr{Bool}), control, name, exists)
end

function clingo_control_symbolic_atoms(control, atoms)
    ccall((:clingo_control_symbolic_atoms, libclingo), Bool, (Ptr{clingo_control_t}, Ptr{Ptr{clingo_symbolic_atoms_t}}), control, atoms)
end

function clingo_control_theory_atoms(control, atoms)
    ccall((:clingo_control_theory_atoms, libclingo), Bool, (Ptr{clingo_control_t}, Ptr{Ptr{clingo_theory_atoms_t}}), control, atoms)
end

function clingo_control_register_observer(control, observer, replace, data)
    ccall((:clingo_control_register_observer, libclingo), Bool, (Ptr{clingo_control_t}, Ptr{clingo_ground_program_observer_t}, Bool, Ptr{Cvoid}), control, observer, replace, data)
end

function clingo_control_backend(control, backend)
    ccall((:clingo_control_backend, libclingo), Bool, (Ptr{clingo_control_t}, Ptr{Ptr{clingo_backend_t}}), control, backend)
end

function clingo_control_program_builder(control, builder)
    ccall((:clingo_control_program_builder, libclingo), Bool, (Ptr{clingo_control_t}, Ptr{Ptr{clingo_program_builder_t}}), control, builder)
end

mutable struct clingo_options end

const clingo_options_t = clingo_options

# typedef bool ( * clingo_main_function_t ) ( clingo_control_t * control , char const * const * files , size_t size , void * data )
const clingo_main_function_t = Ptr{Cvoid}

# typedef bool ( * clingo_default_model_printer_t ) ( void * data )
const clingo_default_model_printer_t = Ptr{Cvoid}

# typedef bool ( * clingo_model_printer_t ) ( clingo_model_t const * model , clingo_default_model_printer_t printer , void * printer_data , void * data )
const clingo_model_printer_t = Ptr{Cvoid}

struct clingo_application
    program_name::Ptr{Cvoid}
    version::Ptr{Cvoid}
    message_limit::Ptr{Cvoid}
    main::clingo_main_function_t
    logger::clingo_logger_t
    printer::clingo_model_printer_t
    register_options::Ptr{Cvoid}
    validate_options::Ptr{Cvoid}
end

const clingo_application_t = clingo_application

function clingo_options_add(options, group, option, description, parse, data, multi, argument)
    ccall((:clingo_options_add, libclingo), Bool, (Ptr{clingo_options_t}, Ptr{Cchar}, Ptr{Cchar}, Ptr{Cchar}, Ptr{Cvoid}, Ptr{Cvoid}, Bool, Ptr{Cchar}), options, group, option, description, parse, data, multi, argument)
end

function clingo_options_add_flag(options, group, option, description, target)
    ccall((:clingo_options_add_flag, libclingo), Bool, (Ptr{clingo_options_t}, Ptr{Cchar}, Ptr{Cchar}, Ptr{Cchar}, Ptr{Bool}), options, group, option, description, target)
end

function clingo_main(application, arguments, size, data)
    ccall((:clingo_main, libclingo), Cint, (Ptr{clingo_application_t}, Ptr{Ptr{Cchar}}, Csize_t, Ptr{Cvoid}), application, arguments, size, data)
end

struct clingo_script
    execute::Ptr{Cvoid}
    call::Ptr{Cvoid}
    callable::Ptr{Cvoid}
    main::Ptr{Cvoid}
    free::Ptr{Cvoid}
    version::Ptr{Cchar}
end

const clingo_script_t = clingo_script

function clingo_register_script(name, script, data)
    ccall((:clingo_register_script, libclingo), Bool, (Ptr{Cchar}, Ptr{clingo_script_t}, Ptr{Cvoid}), name, script, data)
end

function clingo_script_version(name)
    ccall((:clingo_script_version, libclingo), Ptr{Cchar}, (Ptr{Cchar},), name)
end

# Skipping MacroDefinition: CLINGO_VISIBILITY_DEFAULT __attribute__ ( ( visibility ( "default" ) ) )

# Skipping MacroDefinition: CLINGO_VISIBILITY_PRIVATE __attribute__ ( ( visibility ( "hidden" ) ) )

# Skipping MacroDefinition: CLINGO_DEPRECATED __attribute__ ( ( deprecated ) )

const CLINGO_VERSION_MAJOR = 5

const CLINGO_VERSION_MINOR = 5

const CLINGO_VERSION_REVISION = 0

const CLINGO_VERSION = "5.5.0"

end # module
