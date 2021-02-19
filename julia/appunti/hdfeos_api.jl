# Julia wrapper for header: H5ACpublic.h
# Automatically generated using Clang.jl

# Julia wrapper for header: H5Apublic.h
# Automatically generated using Clang.jl


function H5Acreate2(loc_id, attr_name, type_id, space_id, acpl_id, aapl_id)
    ccall((:H5Acreate2, libclang), hid_t, (hid_t, Cstring, hid_t, hid_t, hid_t, hid_t), loc_id, attr_name, type_id, space_id, acpl_id, aapl_id)
end

function H5Acreate_by_name(loc_id, obj_name, attr_name, type_id, space_id, acpl_id, aapl_id, lapl_id)
    ccall((:H5Acreate_by_name, libclang), hid_t, (hid_t, Cstring, Cstring, hid_t, hid_t, hid_t, hid_t, hid_t), loc_id, obj_name, attr_name, type_id, space_id, acpl_id, aapl_id, lapl_id)
end

function H5Aopen(obj_id, attr_name, aapl_id)
    ccall((:H5Aopen, libclang), hid_t, (hid_t, Cstring, hid_t), obj_id, attr_name, aapl_id)
end

function H5Aopen_by_name(loc_id, obj_name, attr_name, aapl_id, lapl_id)
    ccall((:H5Aopen_by_name, libclang), hid_t, (hid_t, Cstring, Cstring, hid_t, hid_t), loc_id, obj_name, attr_name, aapl_id, lapl_id)
end

function H5Aopen_by_idx(loc_id, obj_name, idx_type, order, n, aapl_id, lapl_id)
    ccall((:H5Aopen_by_idx, libclang), hid_t, (hid_t, Cstring, H5_index_t, H5_iter_order_t, hsize_t, hid_t, hid_t), loc_id, obj_name, idx_type, order, n, aapl_id, lapl_id)
end

function H5Awrite(attr_id, type_id, buf)
    ccall((:H5Awrite, libclang), herr_t, (hid_t, hid_t, Ptr{Cvoid}), attr_id, type_id, buf)
end

function H5Aread(attr_id, type_id, buf)
    ccall((:H5Aread, libclang), herr_t, (hid_t, hid_t, Ptr{Cvoid}), attr_id, type_id, buf)
end

function H5Aclose(attr_id)
    ccall((:H5Aclose, libclang), herr_t, (hid_t,), attr_id)
end

function H5Aget_space(attr_id)
    ccall((:H5Aget_space, libclang), hid_t, (hid_t,), attr_id)
end

function H5Aget_type(attr_id)
    ccall((:H5Aget_type, libclang), hid_t, (hid_t,), attr_id)
end

function H5Aget_create_plist(attr_id)
    ccall((:H5Aget_create_plist, libclang), hid_t, (hid_t,), attr_id)
end

function H5Aget_name(attr_id, buf_size, buf)
    ccall((:H5Aget_name, libclang), ssize_t, (hid_t, Csize_t, Cstring), attr_id, buf_size, buf)
end

function H5Aget_name_by_idx(loc_id, obj_name, idx_type, order, n, name, size, lapl_id)
    ccall((:H5Aget_name_by_idx, libclang), ssize_t, (hid_t, Cstring, H5_index_t, H5_iter_order_t, hsize_t, Cstring, Csize_t, hid_t), loc_id, obj_name, idx_type, order, n, name, size, lapl_id)
end

function H5Aget_storage_size(attr_id)
    ccall((:H5Aget_storage_size, libclang), hsize_t, (hid_t,), attr_id)
end

function H5Aget_info(attr_id, ainfo)
    ccall((:H5Aget_info, libclang), herr_t, (hid_t, Ptr{H5A_info_t}), attr_id, ainfo)
end

function H5Aget_info_by_name(loc_id, obj_name, attr_name, ainfo, lapl_id)
    ccall((:H5Aget_info_by_name, libclang), herr_t, (hid_t, Cstring, Cstring, Ptr{H5A_info_t}, hid_t), loc_id, obj_name, attr_name, ainfo, lapl_id)
end

function H5Aget_info_by_idx(loc_id, obj_name, idx_type, order, n, ainfo, lapl_id)
    ccall((:H5Aget_info_by_idx, libclang), herr_t, (hid_t, Cstring, H5_index_t, H5_iter_order_t, hsize_t, Ptr{H5A_info_t}, hid_t), loc_id, obj_name, idx_type, order, n, ainfo, lapl_id)
end

function H5Arename(loc_id, old_name, new_name)
    ccall((:H5Arename, libclang), herr_t, (hid_t, Cstring, Cstring), loc_id, old_name, new_name)
end

function H5Arename_by_name(loc_id, obj_name, old_attr_name, new_attr_name, lapl_id)
    ccall((:H5Arename_by_name, libclang), herr_t, (hid_t, Cstring, Cstring, Cstring, hid_t), loc_id, obj_name, old_attr_name, new_attr_name, lapl_id)
end

function H5Aiterate2(loc_id, idx_type, order, idx, op, op_data)
    ccall((:H5Aiterate2, libclang), herr_t, (hid_t, H5_index_t, H5_iter_order_t, Ptr{hsize_t}, H5A_operator2_t, Ptr{Cvoid}), loc_id, idx_type, order, idx, op, op_data)
end

function H5Aiterate_by_name(loc_id, obj_name, idx_type, order, idx, op, op_data, lapd_id)
    ccall((:H5Aiterate_by_name, libclang), herr_t, (hid_t, Cstring, H5_index_t, H5_iter_order_t, Ptr{hsize_t}, H5A_operator2_t, Ptr{Cvoid}, hid_t), loc_id, obj_name, idx_type, order, idx, op, op_data, lapd_id)
end

function H5Adelete(loc_id, name)
    ccall((:H5Adelete, libclang), herr_t, (hid_t, Cstring), loc_id, name)
end

function H5Adelete_by_name(loc_id, obj_name, attr_name, lapl_id)
    ccall((:H5Adelete_by_name, libclang), herr_t, (hid_t, Cstring, Cstring, hid_t), loc_id, obj_name, attr_name, lapl_id)
end

function H5Adelete_by_idx(loc_id, obj_name, idx_type, order, n, lapl_id)
    ccall((:H5Adelete_by_idx, libclang), herr_t, (hid_t, Cstring, H5_index_t, H5_iter_order_t, hsize_t, hid_t), loc_id, obj_name, idx_type, order, n, lapl_id)
end

function H5Aexists(obj_id, attr_name)
    ccall((:H5Aexists, libclang), htri_t, (hid_t, Cstring), obj_id, attr_name)
end

function H5Aexists_by_name(obj_id, obj_name, attr_name, lapl_id)
    ccall((:H5Aexists_by_name, libclang), htri_t, (hid_t, Cstring, Cstring, hid_t), obj_id, obj_name, attr_name, lapl_id)
end

function H5Acreate1(loc_id, name, type_id, space_id, acpl_id)
    ccall((:H5Acreate1, libclang), hid_t, (hid_t, Cstring, hid_t, hid_t, hid_t), loc_id, name, type_id, space_id, acpl_id)
end

function H5Aopen_name(loc_id, name)
    ccall((:H5Aopen_name, libclang), hid_t, (hid_t, Cstring), loc_id, name)
end

function H5Aopen_idx(loc_id, idx)
    ccall((:H5Aopen_idx, libclang), hid_t, (hid_t, UInt32), loc_id, idx)
end

function H5Aget_num_attrs(loc_id)
    ccall((:H5Aget_num_attrs, libclang), Cint, (hid_t,), loc_id)
end

function H5Aiterate1(loc_id, attr_num, op, op_data)
    ccall((:H5Aiterate1, libclang), herr_t, (hid_t, Ptr{UInt32}, H5A_operator1_t, Ptr{Cvoid}), loc_id, attr_num, op, op_data)
end
# Julia wrapper for header: H5Cpublic.h
# Automatically generated using Clang.jl

# Julia wrapper for header: H5DOpublic.h
# Automatically generated using Clang.jl

# Julia wrapper for header: H5DSpublic.h
# Automatically generated using Clang.jl


function H5DSget_num_scales()
    ccall((:H5DSget_num_scales, libclang), Cint, ())
end
# Julia wrapper for header: H5Dpublic.h
# Automatically generated using Clang.jl


function H5Dcreate2(loc_id, name, type_id, space_id, lcpl_id, dcpl_id, dapl_id)
    ccall((:H5Dcreate2, libclang), hid_t, (hid_t, Cstring, hid_t, hid_t, hid_t, hid_t, hid_t), loc_id, name, type_id, space_id, lcpl_id, dcpl_id, dapl_id)
end

function H5Dcreate_anon(file_id, type_id, space_id, plist_id, dapl_id)
    ccall((:H5Dcreate_anon, libclang), hid_t, (hid_t, hid_t, hid_t, hid_t, hid_t), file_id, type_id, space_id, plist_id, dapl_id)
end

function H5Dopen2(file_id, name, dapl_id)
    ccall((:H5Dopen2, libclang), hid_t, (hid_t, Cstring, hid_t), file_id, name, dapl_id)
end

function H5Dclose(dset_id)
    ccall((:H5Dclose, libclang), herr_t, (hid_t,), dset_id)
end

function H5Dget_space(dset_id)
    ccall((:H5Dget_space, libclang), hid_t, (hid_t,), dset_id)
end

function H5Dget_space_status(dset_id, allocation)
    ccall((:H5Dget_space_status, libclang), herr_t, (hid_t, Ptr{H5D_space_status_t}), dset_id, allocation)
end

function H5Dget_type(dset_id)
    ccall((:H5Dget_type, libclang), hid_t, (hid_t,), dset_id)
end

function H5Dget_create_plist(dset_id)
    ccall((:H5Dget_create_plist, libclang), hid_t, (hid_t,), dset_id)
end

function H5Dget_access_plist(dset_id)
    ccall((:H5Dget_access_plist, libclang), hid_t, (hid_t,), dset_id)
end

function H5Dget_storage_size(dset_id)
    ccall((:H5Dget_storage_size, libclang), hsize_t, (hid_t,), dset_id)
end

function H5Dget_chunk_storage_size(dset_id, offset, chunk_bytes)
    ccall((:H5Dget_chunk_storage_size, libclang), herr_t, (hid_t, Ptr{hsize_t}, Ptr{hsize_t}), dset_id, offset, chunk_bytes)
end

function H5Dget_offset(dset_id)
    ccall((:H5Dget_offset, libclang), haddr_t, (hid_t,), dset_id)
end

function H5Dread(dset_id, mem_type_id, mem_space_id, file_space_id, plist_id, buf)
    ccall((:H5Dread, libclang), herr_t, (hid_t, hid_t, hid_t, hid_t, hid_t, Ptr{Cvoid}), dset_id, mem_type_id, mem_space_id, file_space_id, plist_id, buf)
end

function H5Dwrite(dset_id, mem_type_id, mem_space_id, file_space_id, plist_id, buf)
    ccall((:H5Dwrite, libclang), herr_t, (hid_t, hid_t, hid_t, hid_t, hid_t, Ptr{Cvoid}), dset_id, mem_type_id, mem_space_id, file_space_id, plist_id, buf)
end

function H5Diterate(buf, type_id, space_id, op, operator_data)
    ccall((:H5Diterate, libclang), herr_t, (Ptr{Cvoid}, hid_t, hid_t, H5D_operator_t, Ptr{Cvoid}), buf, type_id, space_id, op, operator_data)
end

function H5Dvlen_reclaim(type_id, space_id, plist_id, buf)
    ccall((:H5Dvlen_reclaim, libclang), herr_t, (hid_t, hid_t, hid_t, Ptr{Cvoid}), type_id, space_id, plist_id, buf)
end

function H5Dvlen_get_buf_size(dataset_id, type_id, space_id, size)
    ccall((:H5Dvlen_get_buf_size, libclang), herr_t, (hid_t, hid_t, hid_t, Ptr{hsize_t}), dataset_id, type_id, space_id, size)
end

function H5Dfill(fill, fill_type, buf, buf_type, space)
    ccall((:H5Dfill, libclang), herr_t, (Ptr{Cvoid}, hid_t, Ptr{Cvoid}, hid_t, hid_t), fill, fill_type, buf, buf_type, space)
end

function H5Dset_extent(dset_id, size)
    ccall((:H5Dset_extent, libclang), herr_t, (hid_t, Ptr{hsize_t}), dset_id, size)
end

function H5Dscatter(op, op_data, type_id, dst_space_id, dst_buf)
    ccall((:H5Dscatter, libclang), herr_t, (H5D_scatter_func_t, Ptr{Cvoid}, hid_t, hid_t, Ptr{Cvoid}), op, op_data, type_id, dst_space_id, dst_buf)
end

function H5Dgather(src_space_id, src_buf, type_id, dst_buf_size, dst_buf, op, op_data)
    ccall((:H5Dgather, libclang), herr_t, (hid_t, Ptr{Cvoid}, hid_t, Csize_t, Ptr{Cvoid}, H5D_gather_func_t, Ptr{Cvoid}), src_space_id, src_buf, type_id, dst_buf_size, dst_buf, op, op_data)
end

function H5Ddebug(dset_id)
    ccall((:H5Ddebug, libclang), herr_t, (hid_t,), dset_id)
end

function H5Dcreate1(file_id, name, type_id, space_id, dcpl_id)
    ccall((:H5Dcreate1, libclang), hid_t, (hid_t, Cstring, hid_t, hid_t, hid_t), file_id, name, type_id, space_id, dcpl_id)
end

function H5Dopen1(file_id, name)
    ccall((:H5Dopen1, libclang), hid_t, (hid_t, Cstring), file_id, name)
end

function H5Dextend(dset_id, size)
    ccall((:H5Dextend, libclang), herr_t, (hid_t, Ptr{hsize_t}), dset_id, size)
end
# Julia wrapper for header: H5Epubgen.h
# Automatically generated using Clang.jl

# Julia wrapper for header: H5Epublic.h
# Automatically generated using Clang.jl


function H5Eregister_class(cls_name, lib_name, version)
    ccall((:H5Eregister_class, libclang), hid_t, (Cstring, Cstring, Cstring), cls_name, lib_name, version)
end

function H5Eunregister_class(class_id)
    ccall((:H5Eunregister_class, libclang), herr_t, (hid_t,), class_id)
end

function H5Eclose_msg(err_id)
    ccall((:H5Eclose_msg, libclang), herr_t, (hid_t,), err_id)
end

function H5Ecreate_msg(cls, msg_type, msg)
    ccall((:H5Ecreate_msg, libclang), hid_t, (hid_t, H5E_type_t, Cstring), cls, msg_type, msg)
end

function H5Ecreate_stack()
    ccall((:H5Ecreate_stack, libclang), hid_t, ())
end

function H5Eget_current_stack()
    ccall((:H5Eget_current_stack, libclang), hid_t, ())
end

function H5Eclose_stack(stack_id)
    ccall((:H5Eclose_stack, libclang), herr_t, (hid_t,), stack_id)
end

function H5Eget_class_name(class_id, name, size)
    ccall((:H5Eget_class_name, libclang), ssize_t, (hid_t, Cstring, Csize_t), class_id, name, size)
end

function H5Eset_current_stack(err_stack_id)
    ccall((:H5Eset_current_stack, libclang), herr_t, (hid_t,), err_stack_id)
end

function H5Epop(err_stack, count)
    ccall((:H5Epop, libclang), herr_t, (hid_t, Csize_t), err_stack, count)
end

function H5Eprint2(err_stack, stream)
    ccall((:H5Eprint2, libclang), herr_t, (hid_t, Ptr{FILE}), err_stack, stream)
end

function H5Ewalk2(err_stack, direction, func, client_data)
    ccall((:H5Ewalk2, libclang), herr_t, (hid_t, H5E_direction_t, H5E_walk2_t, Ptr{Cvoid}), err_stack, direction, func, client_data)
end

function H5Eget_auto2(estack_id, func, client_data)
    ccall((:H5Eget_auto2, libclang), herr_t, (hid_t, Ptr{H5E_auto2_t}, Ptr{Ptr{Cvoid}}), estack_id, func, client_data)
end

function H5Eset_auto2(estack_id, func, client_data)
    ccall((:H5Eset_auto2, libclang), herr_t, (hid_t, H5E_auto2_t, Ptr{Cvoid}), estack_id, func, client_data)
end

function H5Eclear2(err_stack)
    ccall((:H5Eclear2, libclang), herr_t, (hid_t,), err_stack)
end

function H5Eauto_is_v2(err_stack, is_stack)
    ccall((:H5Eauto_is_v2, libclang), herr_t, (hid_t, Ptr{UInt32}), err_stack, is_stack)
end

function H5Eget_msg(msg_id, type, msg, size)
    ccall((:H5Eget_msg, libclang), ssize_t, (hid_t, Ptr{H5E_type_t}, Cstring, Csize_t), msg_id, type, msg, size)
end

function H5Eget_num(error_stack_id)
    ccall((:H5Eget_num, libclang), ssize_t, (hid_t,), error_stack_id)
end

function H5Eclear1()
    ccall((:H5Eclear1, libclang), herr_t, ())
end

function H5Eget_auto1(func, client_data)
    ccall((:H5Eget_auto1, libclang), herr_t, (Ptr{H5E_auto1_t}, Ptr{Ptr{Cvoid}}), func, client_data)
end

function H5Epush1(file, func, line, maj, min, str)
    ccall((:H5Epush1, libclang), herr_t, (Cstring, Cstring, UInt32, H5E_major_t, H5E_minor_t, Cstring), file, func, line, maj, min, str)
end

function H5Eprint1(stream)
    ccall((:H5Eprint1, libclang), herr_t, (Ptr{FILE},), stream)
end

function H5Eset_auto1(func, client_data)
    ccall((:H5Eset_auto1, libclang), herr_t, (H5E_auto1_t, Ptr{Cvoid}), func, client_data)
end

function H5Ewalk1(direction, func, client_data)
    ccall((:H5Ewalk1, libclang), herr_t, (H5E_direction_t, H5E_walk1_t, Ptr{Cvoid}), direction, func, client_data)
end

function H5Eget_major(maj)
    ccall((:H5Eget_major, libclang), Cstring, (H5E_major_t,), maj)
end

function H5Eget_minor(min)
    ccall((:H5Eget_minor, libclang), Cstring, (H5E_minor_t,), min)
end
# Julia wrapper for header: H5FDcore.h
# Automatically generated using Clang.jl


function H5FD_core_init()
    ccall((:H5FD_core_init, libclang), hid_t, ())
end

function H5FD_core_term()
    ccall((:H5FD_core_term, libclang), Cvoid, ())
end

function H5Pset_fapl_core(fapl_id, increment, backing_store)
    ccall((:H5Pset_fapl_core, libclang), herr_t, (hid_t, Csize_t, hbool_t), fapl_id, increment, backing_store)
end

function H5Pget_fapl_core(fapl_id, increment, backing_store)
    ccall((:H5Pget_fapl_core, libclang), herr_t, (hid_t, Ptr{Csize_t}, Ptr{hbool_t}), fapl_id, increment, backing_store)
end
# Julia wrapper for header: H5FDdirect.h
# Automatically generated using Clang.jl

# Julia wrapper for header: H5FDfamily.h
# Automatically generated using Clang.jl


function H5FD_family_init()
    ccall((:H5FD_family_init, libclang), hid_t, ())
end

function H5FD_family_term()
    ccall((:H5FD_family_term, libclang), Cvoid, ())
end

function H5Pset_fapl_family(fapl_id, memb_size, memb_fapl_id)
    ccall((:H5Pset_fapl_family, libclang), herr_t, (hid_t, hsize_t, hid_t), fapl_id, memb_size, memb_fapl_id)
end

function H5Pget_fapl_family(fapl_id, memb_size, memb_fapl_id)
    ccall((:H5Pget_fapl_family, libclang), herr_t, (hid_t, Ptr{hsize_t}, Ptr{hid_t}), fapl_id, memb_size, memb_fapl_id)
end
# Julia wrapper for header: H5FDlog.h
# Automatically generated using Clang.jl


function H5FD_log_init()
    ccall((:H5FD_log_init, libclang), hid_t, ())
end

function H5FD_log_term()
    ccall((:H5FD_log_term, libclang), Cvoid, ())
end

function H5Pset_fapl_log(fapl_id, logfile, flags, buf_size)
    ccall((:H5Pset_fapl_log, libclang), herr_t, (hid_t, Cstring, Culonglong, Csize_t), fapl_id, logfile, flags, buf_size)
end
# Julia wrapper for header: H5FDmpi.h
# Automatically generated using Clang.jl

# Julia wrapper for header: H5FDmpio.h
# Automatically generated using Clang.jl

# Julia wrapper for header: H5FDmulti.h
# Automatically generated using Clang.jl


function H5FD_multi_init()
    ccall((:H5FD_multi_init, libclang), hid_t, ())
end

function H5FD_multi_term()
    ccall((:H5FD_multi_term, libclang), Cvoid, ())
end

function H5Pset_fapl_multi(fapl_id, memb_map, memb_fapl, memb_name, memb_addr, relax)
    ccall((:H5Pset_fapl_multi, libclang), herr_t, (hid_t, Ptr{H5FD_mem_t}, Ptr{hid_t}, Ptr{Cstring}, Ptr{haddr_t}, hbool_t), fapl_id, memb_map, memb_fapl, memb_name, memb_addr, relax)
end

function H5Pget_fapl_multi(fapl_id, memb_map, memb_fapl, memb_name, memb_addr, relax)
    ccall((:H5Pget_fapl_multi, libclang), herr_t, (hid_t, Ptr{H5FD_mem_t}, Ptr{hid_t}, Ptr{Cstring}, Ptr{haddr_t}, Ptr{hbool_t}), fapl_id, memb_map, memb_fapl, memb_name, memb_addr, relax)
end

function H5Pset_fapl_split(fapl, meta_ext, meta_plist_id, raw_ext, raw_plist_id)
    ccall((:H5Pset_fapl_split, libclang), herr_t, (hid_t, Cstring, hid_t, Cstring, hid_t), fapl, meta_ext, meta_plist_id, raw_ext, raw_plist_id)
end
# Julia wrapper for header: H5FDpublic.h
# Automatically generated using Clang.jl


function H5FDregister(cls)
    ccall((:H5FDregister, libclang), hid_t, (Ptr{H5FD_class_t},), cls)
end

function H5FDunregister(driver_id)
    ccall((:H5FDunregister, libclang), herr_t, (hid_t,), driver_id)
end

function H5FDopen(name, flags, fapl_id, maxaddr)
    ccall((:H5FDopen, libclang), Ptr{H5FD_t}, (Cstring, UInt32, hid_t, haddr_t), name, flags, fapl_id, maxaddr)
end

function H5FDclose(file)
    ccall((:H5FDclose, libclang), herr_t, (Ptr{H5FD_t},), file)
end

function H5FDcmp(f1, f2)
    ccall((:H5FDcmp, libclang), Cint, (Ptr{H5FD_t}, Ptr{H5FD_t}), f1, f2)
end

function H5FDquery(f, flags)
    ccall((:H5FDquery, libclang), Cint, (Ptr{H5FD_t}, Ptr{Culong}), f, flags)
end

function H5FDalloc(file, type, dxpl_id, size)
    ccall((:H5FDalloc, libclang), haddr_t, (Ptr{H5FD_t}, H5FD_mem_t, hid_t, hsize_t), file, type, dxpl_id, size)
end

function H5FDfree(file, type, dxpl_id, addr, size)
    ccall((:H5FDfree, libclang), herr_t, (Ptr{H5FD_t}, H5FD_mem_t, hid_t, haddr_t, hsize_t), file, type, dxpl_id, addr, size)
end

function H5FDget_eoa(file, type)
    ccall((:H5FDget_eoa, libclang), haddr_t, (Ptr{H5FD_t}, H5FD_mem_t), file, type)
end

function H5FDset_eoa(file, type, eoa)
    ccall((:H5FDset_eoa, libclang), herr_t, (Ptr{H5FD_t}, H5FD_mem_t, haddr_t), file, type, eoa)
end

function H5FDget_eof(file)
    ccall((:H5FDget_eof, libclang), haddr_t, (Ptr{H5FD_t},), file)
end

function H5FDget_vfd_handle(file, fapl, file_handle)
    ccall((:H5FDget_vfd_handle, libclang), herr_t, (Ptr{H5FD_t}, hid_t, Ptr{Ptr{Cvoid}}), file, fapl, file_handle)
end

function H5FDread(file, type, dxpl_id, addr, size, buf)
    ccall((:H5FDread, libclang), herr_t, (Ptr{H5FD_t}, H5FD_mem_t, hid_t, haddr_t, Csize_t, Ptr{Cvoid}), file, type, dxpl_id, addr, size, buf)
end

function H5FDwrite(file, type, dxpl_id, addr, size, buf)
    ccall((:H5FDwrite, libclang), herr_t, (Ptr{H5FD_t}, H5FD_mem_t, hid_t, haddr_t, Csize_t, Ptr{Cvoid}), file, type, dxpl_id, addr, size, buf)
end

function H5FDflush(file, dxpl_id, closing)
    ccall((:H5FDflush, libclang), herr_t, (Ptr{H5FD_t}, hid_t, UInt32), file, dxpl_id, closing)
end

function H5FDtruncate(file, dxpl_id, closing)
    ccall((:H5FDtruncate, libclang), herr_t, (Ptr{H5FD_t}, hid_t, hbool_t), file, dxpl_id, closing)
end
# Julia wrapper for header: H5FDsec2.h
# Automatically generated using Clang.jl


function H5FD_sec2_init()
    ccall((:H5FD_sec2_init, libclang), hid_t, ())
end

function H5FD_sec2_term()
    ccall((:H5FD_sec2_term, libclang), Cvoid, ())
end

function H5Pset_fapl_sec2(fapl_id)
    ccall((:H5Pset_fapl_sec2, libclang), herr_t, (hid_t,), fapl_id)
end
# Julia wrapper for header: H5FDstdio.h
# Automatically generated using Clang.jl


function H5FD_stdio_init()
    ccall((:H5FD_stdio_init, libclang), hid_t, ())
end

function H5FD_stdio_term()
    ccall((:H5FD_stdio_term, libclang), Cvoid, ())
end

function H5Pset_fapl_stdio(fapl_id)
    ccall((:H5Pset_fapl_stdio, libclang), herr_t, (hid_t,), fapl_id)
end
# Julia wrapper for header: H5Fpublic.h
# Automatically generated using Clang.jl


function H5Fis_hdf5(filename)
    ccall((:H5Fis_hdf5, libclang), htri_t, (Cstring,), filename)
end

function H5Fcreate(filename, flags, create_plist, access_plist)
    ccall((:H5Fcreate, libclang), hid_t, (Cstring, UInt32, hid_t, hid_t), filename, flags, create_plist, access_plist)
end

function H5Fopen(filename, flags, access_plist)
    ccall((:H5Fopen, libclang), hid_t, (Cstring, UInt32, hid_t), filename, flags, access_plist)
end

function H5Freopen(file_id)
    ccall((:H5Freopen, libclang), hid_t, (hid_t,), file_id)
end

function H5Fflush(object_id, scope)
    ccall((:H5Fflush, libclang), herr_t, (hid_t, H5F_scope_t), object_id, scope)
end

function H5Fclose(file_id)
    ccall((:H5Fclose, libclang), herr_t, (hid_t,), file_id)
end

function H5Fget_create_plist(file_id)
    ccall((:H5Fget_create_plist, libclang), hid_t, (hid_t,), file_id)
end

function H5Fget_access_plist(file_id)
    ccall((:H5Fget_access_plist, libclang), hid_t, (hid_t,), file_id)
end

function H5Fget_intent(file_id, intent)
    ccall((:H5Fget_intent, libclang), herr_t, (hid_t, Ptr{UInt32}), file_id, intent)
end

function H5Fget_obj_count(file_id, types)
    ccall((:H5Fget_obj_count, libclang), ssize_t, (hid_t, UInt32), file_id, types)
end

function H5Fget_obj_ids(file_id, types, max_objs, obj_id_list)
    ccall((:H5Fget_obj_ids, libclang), ssize_t, (hid_t, UInt32, Csize_t, Ptr{hid_t}), file_id, types, max_objs, obj_id_list)
end

function H5Fget_vfd_handle(file_id, fapl, file_handle)
    ccall((:H5Fget_vfd_handle, libclang), herr_t, (hid_t, hid_t, Ptr{Ptr{Cvoid}}), file_id, fapl, file_handle)
end

function H5Fmount(loc, name, child, plist)
    ccall((:H5Fmount, libclang), herr_t, (hid_t, Cstring, hid_t, hid_t), loc, name, child, plist)
end

function H5Funmount(loc, name)
    ccall((:H5Funmount, libclang), herr_t, (hid_t, Cstring), loc, name)
end

function H5Fget_freespace(file_id)
    ccall((:H5Fget_freespace, libclang), hssize_t, (hid_t,), file_id)
end

function H5Fget_filesize(file_id, size)
    ccall((:H5Fget_filesize, libclang), herr_t, (hid_t, Ptr{hsize_t}), file_id, size)
end

function H5Fget_file_image(file_id, buf_ptr, buf_len)
    ccall((:H5Fget_file_image, libclang), ssize_t, (hid_t, Ptr{Cvoid}, Csize_t), file_id, buf_ptr, buf_len)
end

function H5Fget_mdc_config(file_id, config_ptr)
    ccall((:H5Fget_mdc_config, libclang), herr_t, (hid_t, Ptr{H5AC_cache_config_t}), file_id, config_ptr)
end

function H5Fset_mdc_config(file_id, config_ptr)
    ccall((:H5Fset_mdc_config, libclang), herr_t, (hid_t, Ptr{H5AC_cache_config_t}), file_id, config_ptr)
end

function H5Fget_mdc_hit_rate(file_id, hit_rate_ptr)
    ccall((:H5Fget_mdc_hit_rate, libclang), herr_t, (hid_t, Ptr{Cdouble}), file_id, hit_rate_ptr)
end

function H5Fget_mdc_size(file_id, max_size_ptr, min_clean_size_ptr, cur_size_ptr, cur_num_entries_ptr)
    ccall((:H5Fget_mdc_size, libclang), herr_t, (hid_t, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cint}), file_id, max_size_ptr, min_clean_size_ptr, cur_size_ptr, cur_num_entries_ptr)
end

function H5Freset_mdc_hit_rate_stats(file_id)
    ccall((:H5Freset_mdc_hit_rate_stats, libclang), herr_t, (hid_t,), file_id)
end

function H5Fget_name(obj_id, name, size)
    ccall((:H5Fget_name, libclang), ssize_t, (hid_t, Cstring, Csize_t), obj_id, name, size)
end

function H5Fget_info(obj_id, bh_info)
    ccall((:H5Fget_info, libclang), herr_t, (hid_t, Ptr{H5F_info_t}), obj_id, bh_info)
end

function H5Fclear_elink_file_cache(file_id)
    ccall((:H5Fclear_elink_file_cache, libclang), herr_t, (hid_t,), file_id)
end
# Julia wrapper for header: H5Gpublic.h
# Automatically generated using Clang.jl


function H5Gcreate2(loc_id, name, lcpl_id, gcpl_id, gapl_id)
    ccall((:H5Gcreate2, libclang), hid_t, (hid_t, Cstring, hid_t, hid_t, hid_t), loc_id, name, lcpl_id, gcpl_id, gapl_id)
end

function H5Gcreate_anon(loc_id, gcpl_id, gapl_id)
    ccall((:H5Gcreate_anon, libclang), hid_t, (hid_t, hid_t, hid_t), loc_id, gcpl_id, gapl_id)
end

function H5Gopen2(loc_id, name, gapl_id)
    ccall((:H5Gopen2, libclang), hid_t, (hid_t, Cstring, hid_t), loc_id, name, gapl_id)
end

function H5Gget_create_plist(group_id)
    ccall((:H5Gget_create_plist, libclang), hid_t, (hid_t,), group_id)
end

function H5Gget_info(loc_id, ginfo)
    ccall((:H5Gget_info, libclang), herr_t, (hid_t, Ptr{H5G_info_t}), loc_id, ginfo)
end

function H5Gget_info_by_name(loc_id, name, ginfo, lapl_id)
    ccall((:H5Gget_info_by_name, libclang), herr_t, (hid_t, Cstring, Ptr{H5G_info_t}, hid_t), loc_id, name, ginfo, lapl_id)
end

function H5Gget_info_by_idx(loc_id, group_name, idx_type, order, n, ginfo, lapl_id)
    ccall((:H5Gget_info_by_idx, libclang), herr_t, (hid_t, Cstring, H5_index_t, H5_iter_order_t, hsize_t, Ptr{H5G_info_t}, hid_t), loc_id, group_name, idx_type, order, n, ginfo, lapl_id)
end

function H5Gclose(group_id)
    ccall((:H5Gclose, libclang), herr_t, (hid_t,), group_id)
end

function H5Gcreate1(loc_id, name, size_hint)
    ccall((:H5Gcreate1, libclang), hid_t, (hid_t, Cstring, Csize_t), loc_id, name, size_hint)
end

function H5Gopen1(loc_id, name)
    ccall((:H5Gopen1, libclang), hid_t, (hid_t, Cstring), loc_id, name)
end

function H5Glink(cur_loc_id, type, cur_name, new_name)
    ccall((:H5Glink, libclang), herr_t, (hid_t, H5L_type_t, Cstring, Cstring), cur_loc_id, type, cur_name, new_name)
end

function H5Glink2(cur_loc_id, cur_name, type, new_loc_id, new_name)
    ccall((:H5Glink2, libclang), herr_t, (hid_t, Cstring, H5L_type_t, hid_t, Cstring), cur_loc_id, cur_name, type, new_loc_id, new_name)
end

function H5Gmove(src_loc_id, src_name, dst_name)
    ccall((:H5Gmove, libclang), herr_t, (hid_t, Cstring, Cstring), src_loc_id, src_name, dst_name)
end

function H5Gmove2(src_loc_id, src_name, dst_loc_id, dst_name)
    ccall((:H5Gmove2, libclang), herr_t, (hid_t, Cstring, hid_t, Cstring), src_loc_id, src_name, dst_loc_id, dst_name)
end

function H5Gunlink(loc_id, name)
    ccall((:H5Gunlink, libclang), herr_t, (hid_t, Cstring), loc_id, name)
end

function H5Gget_linkval(loc_id, name, size, buf)
    ccall((:H5Gget_linkval, libclang), herr_t, (hid_t, Cstring, Csize_t, Cstring), loc_id, name, size, buf)
end

function H5Gset_comment(loc_id, name, comment)
    ccall((:H5Gset_comment, libclang), herr_t, (hid_t, Cstring, Cstring), loc_id, name, comment)
end

function H5Gget_comment(loc_id, name, bufsize, buf)
    ccall((:H5Gget_comment, libclang), Cint, (hid_t, Cstring, Csize_t, Cstring), loc_id, name, bufsize, buf)
end

function H5Giterate(loc_id, name, idx, op, op_data)
    ccall((:H5Giterate, libclang), herr_t, (hid_t, Cstring, Ptr{Cint}, H5G_iterate_t, Ptr{Cvoid}), loc_id, name, idx, op, op_data)
end

function H5Gget_num_objs(loc_id, num_objs)
    ccall((:H5Gget_num_objs, libclang), herr_t, (hid_t, Ptr{hsize_t}), loc_id, num_objs)
end

function H5Gget_objinfo(loc_id, name, follow_link, statbuf)
    ccall((:H5Gget_objinfo, libclang), herr_t, (hid_t, Cstring, hbool_t, Ptr{H5G_stat_t}), loc_id, name, follow_link, statbuf)
end

function H5Gget_objname_by_idx(loc_id, idx, name, size)
    ccall((:H5Gget_objname_by_idx, libclang), ssize_t, (hid_t, hsize_t, Cstring, Csize_t), loc_id, idx, name, size)
end

function H5Gget_objtype_by_idx(loc_id, idx)
    ccall((:H5Gget_objtype_by_idx, libclang), H5G_obj_t, (hid_t, hsize_t), loc_id, idx)
end
# Julia wrapper for header: H5IMpublic.h
# Automatically generated using Clang.jl

# Julia wrapper for header: H5Ipublic.h
# Automatically generated using Clang.jl


function H5Iregister(type, object)
    ccall((:H5Iregister, libclang), hid_t, (H5I_type_t, Ptr{Cvoid}), type, object)
end

function H5Iobject_verify(id, id_type)
    ccall((:H5Iobject_verify, libclang), Ptr{Cvoid}, (hid_t, H5I_type_t), id, id_type)
end

function H5Iremove_verify(id, id_type)
    ccall((:H5Iremove_verify, libclang), Ptr{Cvoid}, (hid_t, H5I_type_t), id, id_type)
end

function H5Iget_type(id)
    ccall((:H5Iget_type, libclang), H5I_type_t, (hid_t,), id)
end

function H5Iget_file_id(id)
    ccall((:H5Iget_file_id, libclang), hid_t, (hid_t,), id)
end

function H5Iget_name(id, name, size)
    ccall((:H5Iget_name, libclang), ssize_t, (hid_t, Cstring, Csize_t), id, name, size)
end

function H5Iinc_ref(id)
    ccall((:H5Iinc_ref, libclang), Cint, (hid_t,), id)
end

function H5Idec_ref(id)
    ccall((:H5Idec_ref, libclang), Cint, (hid_t,), id)
end

function H5Iget_ref(id)
    ccall((:H5Iget_ref, libclang), Cint, (hid_t,), id)
end

function H5Iregister_type(hash_size, reserved, free_func)
    ccall((:H5Iregister_type, libclang), H5I_type_t, (Csize_t, UInt32, H5I_free_t), hash_size, reserved, free_func)
end

function H5Iclear_type(type, force)
    ccall((:H5Iclear_type, libclang), herr_t, (H5I_type_t, hbool_t), type, force)
end

function H5Idestroy_type(type)
    ccall((:H5Idestroy_type, libclang), herr_t, (H5I_type_t,), type)
end

function H5Iinc_type_ref(type)
    ccall((:H5Iinc_type_ref, libclang), Cint, (H5I_type_t,), type)
end

function H5Idec_type_ref(type)
    ccall((:H5Idec_type_ref, libclang), Cint, (H5I_type_t,), type)
end

function H5Iget_type_ref(type)
    ccall((:H5Iget_type_ref, libclang), Cint, (H5I_type_t,), type)
end

function H5Isearch(type, func, key)
    ccall((:H5Isearch, libclang), Ptr{Cvoid}, (H5I_type_t, H5I_search_func_t, Ptr{Cvoid}), type, func, key)
end

function H5Inmembers(type, num_members)
    ccall((:H5Inmembers, libclang), herr_t, (H5I_type_t, Ptr{hsize_t}), type, num_members)
end

function H5Itype_exists(type)
    ccall((:H5Itype_exists, libclang), htri_t, (H5I_type_t,), type)
end

function H5Iis_valid(id)
    ccall((:H5Iis_valid, libclang), htri_t, (hid_t,), id)
end
# Julia wrapper for header: H5LTpublic.h
# Automatically generated using Clang.jl

# Julia wrapper for header: H5Lpublic.h
# Automatically generated using Clang.jl


function H5Lmove(src_loc, src_name, dst_loc, dst_name, lcpl_id, lapl_id)
    ccall((:H5Lmove, libclang), herr_t, (hid_t, Cstring, hid_t, Cstring, hid_t, hid_t), src_loc, src_name, dst_loc, dst_name, lcpl_id, lapl_id)
end

function H5Lcopy(src_loc, src_name, dst_loc, dst_name, lcpl_id, lapl_id)
    ccall((:H5Lcopy, libclang), herr_t, (hid_t, Cstring, hid_t, Cstring, hid_t, hid_t), src_loc, src_name, dst_loc, dst_name, lcpl_id, lapl_id)
end

function H5Lcreate_hard(cur_loc, cur_name, dst_loc, dst_name, lcpl_id, lapl_id)
    ccall((:H5Lcreate_hard, libclang), herr_t, (hid_t, Cstring, hid_t, Cstring, hid_t, hid_t), cur_loc, cur_name, dst_loc, dst_name, lcpl_id, lapl_id)
end

function H5Lcreate_soft(link_target, link_loc_id, link_name, lcpl_id, lapl_id)
    ccall((:H5Lcreate_soft, libclang), herr_t, (Cstring, hid_t, Cstring, hid_t, hid_t), link_target, link_loc_id, link_name, lcpl_id, lapl_id)
end

function H5Ldelete(loc_id, name, lapl_id)
    ccall((:H5Ldelete, libclang), herr_t, (hid_t, Cstring, hid_t), loc_id, name, lapl_id)
end

function H5Ldelete_by_idx(loc_id, group_name, idx_type, order, n, lapl_id)
    ccall((:H5Ldelete_by_idx, libclang), herr_t, (hid_t, Cstring, H5_index_t, H5_iter_order_t, hsize_t, hid_t), loc_id, group_name, idx_type, order, n, lapl_id)
end

function H5Lget_val(loc_id, name, buf, size, lapl_id)
    ccall((:H5Lget_val, libclang), herr_t, (hid_t, Cstring, Ptr{Cvoid}, Csize_t, hid_t), loc_id, name, buf, size, lapl_id)
end

function H5Lget_val_by_idx(loc_id, group_name, idx_type, order, n, buf, size, lapl_id)
    ccall((:H5Lget_val_by_idx, libclang), herr_t, (hid_t, Cstring, H5_index_t, H5_iter_order_t, hsize_t, Ptr{Cvoid}, Csize_t, hid_t), loc_id, group_name, idx_type, order, n, buf, size, lapl_id)
end

function H5Lexists(loc_id, name, lapl_id)
    ccall((:H5Lexists, libclang), htri_t, (hid_t, Cstring, hid_t), loc_id, name, lapl_id)
end

function H5Lget_info(loc_id, name, linfo, lapl_id)
    ccall((:H5Lget_info, libclang), herr_t, (hid_t, Cstring, Ptr{H5L_info_t}, hid_t), loc_id, name, linfo, lapl_id)
end

function H5Lget_info_by_idx(loc_id, group_name, idx_type, order, n, linfo, lapl_id)
    ccall((:H5Lget_info_by_idx, libclang), herr_t, (hid_t, Cstring, H5_index_t, H5_iter_order_t, hsize_t, Ptr{H5L_info_t}, hid_t), loc_id, group_name, idx_type, order, n, linfo, lapl_id)
end

function H5Lget_name_by_idx(loc_id, group_name, idx_type, order, n, name, size, lapl_id)
    ccall((:H5Lget_name_by_idx, libclang), ssize_t, (hid_t, Cstring, H5_index_t, H5_iter_order_t, hsize_t, Cstring, Csize_t, hid_t), loc_id, group_name, idx_type, order, n, name, size, lapl_id)
end

function H5Literate(grp_id, idx_type, order, idx, op, op_data)
    ccall((:H5Literate, libclang), herr_t, (hid_t, H5_index_t, H5_iter_order_t, Ptr{hsize_t}, H5L_iterate_t, Ptr{Cvoid}), grp_id, idx_type, order, idx, op, op_data)
end

function H5Literate_by_name(loc_id, group_name, idx_type, order, idx, op, op_data, lapl_id)
    ccall((:H5Literate_by_name, libclang), herr_t, (hid_t, Cstring, H5_index_t, H5_iter_order_t, Ptr{hsize_t}, H5L_iterate_t, Ptr{Cvoid}, hid_t), loc_id, group_name, idx_type, order, idx, op, op_data, lapl_id)
end

function H5Lvisit(grp_id, idx_type, order, op, op_data)
    ccall((:H5Lvisit, libclang), herr_t, (hid_t, H5_index_t, H5_iter_order_t, H5L_iterate_t, Ptr{Cvoid}), grp_id, idx_type, order, op, op_data)
end

function H5Lvisit_by_name(loc_id, group_name, idx_type, order, op, op_data, lapl_id)
    ccall((:H5Lvisit_by_name, libclang), herr_t, (hid_t, Cstring, H5_index_t, H5_iter_order_t, H5L_iterate_t, Ptr{Cvoid}, hid_t), loc_id, group_name, idx_type, order, op, op_data, lapl_id)
end

function H5Lcreate_ud(link_loc_id, link_name, link_type, udata, udata_size, lcpl_id, lapl_id)
    ccall((:H5Lcreate_ud, libclang), herr_t, (hid_t, Cstring, H5L_type_t, Ptr{Cvoid}, Csize_t, hid_t, hid_t), link_loc_id, link_name, link_type, udata, udata_size, lcpl_id, lapl_id)
end

function H5Lregister(cls)
    ccall((:H5Lregister, libclang), herr_t, (Ptr{H5L_class_t},), cls)
end

function H5Lunregister(id)
    ccall((:H5Lunregister, libclang), herr_t, (H5L_type_t,), id)
end

function H5Lis_registered(id)
    ccall((:H5Lis_registered, libclang), htri_t, (H5L_type_t,), id)
end

function H5Lunpack_elink_val(ext_linkval, link_size, flags, filename, obj_path)
    ccall((:H5Lunpack_elink_val, libclang), herr_t, (Ptr{Cvoid}, Csize_t, Ptr{UInt32}, Ptr{Cstring}, Ptr{Cstring}), ext_linkval, link_size, flags, filename, obj_path)
end

function H5Lcreate_external(file_name, obj_name, link_loc_id, link_name, lcpl_id, lapl_id)
    ccall((:H5Lcreate_external, libclang), herr_t, (Cstring, Cstring, hid_t, Cstring, hid_t, hid_t), file_name, obj_name, link_loc_id, link_name, lcpl_id, lapl_id)
end
# Julia wrapper for header: H5MMpublic.h
# Automatically generated using Clang.jl

# Julia wrapper for header: H5Opublic.h
# Automatically generated using Clang.jl


function H5Oopen(loc_id, name, lapl_id)
    ccall((:H5Oopen, libclang), hid_t, (hid_t, Cstring, hid_t), loc_id, name, lapl_id)
end

function H5Oopen_by_addr(loc_id, addr)
    ccall((:H5Oopen_by_addr, libclang), hid_t, (hid_t, haddr_t), loc_id, addr)
end

function H5Oopen_by_idx(loc_id, group_name, idx_type, order, n, lapl_id)
    ccall((:H5Oopen_by_idx, libclang), hid_t, (hid_t, Cstring, H5_index_t, H5_iter_order_t, hsize_t, hid_t), loc_id, group_name, idx_type, order, n, lapl_id)
end

function H5Oexists_by_name(loc_id, name, lapl_id)
    ccall((:H5Oexists_by_name, libclang), htri_t, (hid_t, Cstring, hid_t), loc_id, name, lapl_id)
end

function H5Oget_info(loc_id, oinfo)
    ccall((:H5Oget_info, libclang), herr_t, (hid_t, Ptr{H5O_info_t}), loc_id, oinfo)
end

function H5Oget_info_by_name(loc_id, name, oinfo, lapl_id)
    ccall((:H5Oget_info_by_name, libclang), herr_t, (hid_t, Cstring, Ptr{H5O_info_t}, hid_t), loc_id, name, oinfo, lapl_id)
end

function H5Oget_info_by_idx(loc_id, group_name, idx_type, order, n, oinfo, lapl_id)
    ccall((:H5Oget_info_by_idx, libclang), herr_t, (hid_t, Cstring, H5_index_t, H5_iter_order_t, hsize_t, Ptr{H5O_info_t}, hid_t), loc_id, group_name, idx_type, order, n, oinfo, lapl_id)
end

function H5Olink(obj_id, new_loc_id, new_name, lcpl_id, lapl_id)
    ccall((:H5Olink, libclang), herr_t, (hid_t, hid_t, Cstring, hid_t, hid_t), obj_id, new_loc_id, new_name, lcpl_id, lapl_id)
end

function H5Oincr_refcount(object_id)
    ccall((:H5Oincr_refcount, libclang), herr_t, (hid_t,), object_id)
end

function H5Odecr_refcount(object_id)
    ccall((:H5Odecr_refcount, libclang), herr_t, (hid_t,), object_id)
end

function H5Ocopy(src_loc_id, src_name, dst_loc_id, dst_name, ocpypl_id, lcpl_id)
    ccall((:H5Ocopy, libclang), herr_t, (hid_t, Cstring, hid_t, Cstring, hid_t, hid_t), src_loc_id, src_name, dst_loc_id, dst_name, ocpypl_id, lcpl_id)
end

function H5Oset_comment(obj_id, comment)
    ccall((:H5Oset_comment, libclang), herr_t, (hid_t, Cstring), obj_id, comment)
end

function H5Oset_comment_by_name(loc_id, name, comment, lapl_id)
    ccall((:H5Oset_comment_by_name, libclang), herr_t, (hid_t, Cstring, Cstring, hid_t), loc_id, name, comment, lapl_id)
end

function H5Oget_comment(obj_id, comment, bufsize)
    ccall((:H5Oget_comment, libclang), ssize_t, (hid_t, Cstring, Csize_t), obj_id, comment, bufsize)
end

function H5Oget_comment_by_name(loc_id, name, comment, bufsize, lapl_id)
    ccall((:H5Oget_comment_by_name, libclang), ssize_t, (hid_t, Cstring, Cstring, Csize_t, hid_t), loc_id, name, comment, bufsize, lapl_id)
end

function H5Ovisit(obj_id, idx_type, order, op, op_data)
    ccall((:H5Ovisit, libclang), herr_t, (hid_t, H5_index_t, H5_iter_order_t, H5O_iterate_t, Ptr{Cvoid}), obj_id, idx_type, order, op, op_data)
end

function H5Ovisit_by_name(loc_id, obj_name, idx_type, order, op, op_data, lapl_id)
    ccall((:H5Ovisit_by_name, libclang), herr_t, (hid_t, Cstring, H5_index_t, H5_iter_order_t, H5O_iterate_t, Ptr{Cvoid}, hid_t), loc_id, obj_name, idx_type, order, op, op_data, lapl_id)
end

function H5Oclose(object_id)
    ccall((:H5Oclose, libclang), herr_t, (hid_t,), object_id)
end
# Julia wrapper for header: H5PLextern.h
# Automatically generated using Clang.jl


function H5PLget_plugin_type()
    ccall((:H5PLget_plugin_type, libclang), H5PL_type_t, ())
end

function H5PLget_plugin_info()
    ccall((:H5PLget_plugin_info, libclang), Ptr{Cvoid}, ())
end
# Julia wrapper for header: H5PLpublic.h
# Automatically generated using Clang.jl


function H5PLset_loading_state(plugin_type)
    ccall((:H5PLset_loading_state, libclang), herr_t, (UInt32,), plugin_type)
end

function H5PLget_loading_state(plugin_type)
    ccall((:H5PLget_loading_state, libclang), herr_t, (Ptr{UInt32},), plugin_type)
end

function H5PLappend(plugin_path)
    ccall((:H5PLappend, libclang), herr_t, (Cstring,), plugin_path)
end

function H5PLprepend(plugin_path)
    ccall((:H5PLprepend, libclang), herr_t, (Cstring,), plugin_path)
end

function H5PLreplace(plugin_path, index)
    ccall((:H5PLreplace, libclang), herr_t, (Cstring, UInt32), plugin_path, index)
end

function H5PLinsert(plugin_path, index)
    ccall((:H5PLinsert, libclang), herr_t, (Cstring, UInt32), plugin_path, index)
end

function H5PLremove(index)
    ccall((:H5PLremove, libclang), herr_t, (UInt32,), index)
end

function H5PLget(index, pathname, size)
    ccall((:H5PLget, libclang), ssize_t, (UInt32, Cstring, Csize_t), index, pathname, size)
end

function H5PLsize(listsize)
    ccall((:H5PLsize, libclang), herr_t, (Ptr{UInt32},), listsize)
end
# Julia wrapper for header: H5PTpublic.h
# Automatically generated using Clang.jl

# Julia wrapper for header: H5Ppublic.h
# Automatically generated using Clang.jl


function H5Pcreate_class(parent, name, cls_create, create_data, cls_copy, copy_data, cls_close, close_data)
    ccall((:H5Pcreate_class, libclang), hid_t, (hid_t, Cstring, H5P_cls_create_func_t, Ptr{Cvoid}, H5P_cls_copy_func_t, Ptr{Cvoid}, H5P_cls_close_func_t, Ptr{Cvoid}), parent, name, cls_create, create_data, cls_copy, copy_data, cls_close, close_data)
end

function H5Pget_class_name(pclass_id)
    ccall((:H5Pget_class_name, libclang), Cstring, (hid_t,), pclass_id)
end

function H5Pcreate(cls_id)
    ccall((:H5Pcreate, libclang), hid_t, (hid_t,), cls_id)
end

function H5Pregister2(cls_id, name, size, def_value, prp_create, prp_set, prp_get, prp_del, prp_copy, prp_cmp, prp_close)
    ccall((:H5Pregister2, libclang), herr_t, (hid_t, Cstring, Csize_t, Ptr{Cvoid}, H5P_prp_create_func_t, H5P_prp_set_func_t, H5P_prp_get_func_t, H5P_prp_delete_func_t, H5P_prp_copy_func_t, H5P_prp_compare_func_t, H5P_prp_close_func_t), cls_id, name, size, def_value, prp_create, prp_set, prp_get, prp_del, prp_copy, prp_cmp, prp_close)
end

function H5Pinsert2(plist_id, name, size, value, prp_set, prp_get, prp_delete, prp_copy, prp_cmp, prp_close)
    ccall((:H5Pinsert2, libclang), herr_t, (hid_t, Cstring, Csize_t, Ptr{Cvoid}, H5P_prp_set_func_t, H5P_prp_get_func_t, H5P_prp_delete_func_t, H5P_prp_copy_func_t, H5P_prp_compare_func_t, H5P_prp_close_func_t), plist_id, name, size, value, prp_set, prp_get, prp_delete, prp_copy, prp_cmp, prp_close)
end

function H5Pset(plist_id, name, value)
    ccall((:H5Pset, libclang), herr_t, (hid_t, Cstring, Ptr{Cvoid}), plist_id, name, value)
end

function H5Pexist(plist_id, name)
    ccall((:H5Pexist, libclang), htri_t, (hid_t, Cstring), plist_id, name)
end

function H5Pget_size(id, name, size)
    ccall((:H5Pget_size, libclang), herr_t, (hid_t, Cstring, Ptr{Csize_t}), id, name, size)
end

function H5Pget_nprops(id, nprops)
    ccall((:H5Pget_nprops, libclang), herr_t, (hid_t, Ptr{Csize_t}), id, nprops)
end

function H5Pget_class(plist_id)
    ccall((:H5Pget_class, libclang), hid_t, (hid_t,), plist_id)
end

function H5Pget_class_parent(pclass_id)
    ccall((:H5Pget_class_parent, libclang), hid_t, (hid_t,), pclass_id)
end

function H5Pget(plist_id, name, value)
    ccall((:H5Pget, libclang), herr_t, (hid_t, Cstring, Ptr{Cvoid}), plist_id, name, value)
end

function H5Pequal(id1, id2)
    ccall((:H5Pequal, libclang), htri_t, (hid_t, hid_t), id1, id2)
end

function H5Pisa_class(plist_id, pclass_id)
    ccall((:H5Pisa_class, libclang), htri_t, (hid_t, hid_t), plist_id, pclass_id)
end

function H5Piterate(id, idx, iter_func, iter_data)
    ccall((:H5Piterate, libclang), Cint, (hid_t, Ptr{Cint}, H5P_iterate_t, Ptr{Cvoid}), id, idx, iter_func, iter_data)
end

function H5Pcopy_prop(dst_id, src_id, name)
    ccall((:H5Pcopy_prop, libclang), herr_t, (hid_t, hid_t, Cstring), dst_id, src_id, name)
end

function H5Premove(plist_id, name)
    ccall((:H5Premove, libclang), herr_t, (hid_t, Cstring), plist_id, name)
end

function H5Punregister(pclass_id, name)
    ccall((:H5Punregister, libclang), herr_t, (hid_t, Cstring), pclass_id, name)
end

function H5Pclose_class(plist_id)
    ccall((:H5Pclose_class, libclang), herr_t, (hid_t,), plist_id)
end

function H5Pclose(plist_id)
    ccall((:H5Pclose, libclang), herr_t, (hid_t,), plist_id)
end

function H5Pcopy(plist_id)
    ccall((:H5Pcopy, libclang), hid_t, (hid_t,), plist_id)
end

function H5Pset_attr_phase_change(plist_id, max_compact, min_dense)
    ccall((:H5Pset_attr_phase_change, libclang), herr_t, (hid_t, UInt32, UInt32), plist_id, max_compact, min_dense)
end

function H5Pget_attr_phase_change(plist_id, max_compact, min_dense)
    ccall((:H5Pget_attr_phase_change, libclang), herr_t, (hid_t, Ptr{UInt32}, Ptr{UInt32}), plist_id, max_compact, min_dense)
end

function H5Pset_attr_creation_order(plist_id, crt_order_flags)
    ccall((:H5Pset_attr_creation_order, libclang), herr_t, (hid_t, UInt32), plist_id, crt_order_flags)
end

function H5Pget_attr_creation_order(plist_id, crt_order_flags)
    ccall((:H5Pget_attr_creation_order, libclang), herr_t, (hid_t, Ptr{UInt32}), plist_id, crt_order_flags)
end

function H5Pset_obj_track_times(plist_id, track_times)
    ccall((:H5Pset_obj_track_times, libclang), herr_t, (hid_t, hbool_t), plist_id, track_times)
end

function H5Pget_obj_track_times(plist_id, track_times)
    ccall((:H5Pget_obj_track_times, libclang), herr_t, (hid_t, Ptr{hbool_t}), plist_id, track_times)
end

function H5Pmodify_filter(plist_id, filter, flags, cd_nelmts, cd_values)
    ccall((:H5Pmodify_filter, libclang), herr_t, (hid_t, H5Z_filter_t, UInt32, Csize_t, Ptr{UInt32}), plist_id, filter, flags, cd_nelmts, cd_values)
end

function H5Pset_filter(plist_id, filter, flags, cd_nelmts, c_values)
    ccall((:H5Pset_filter, libclang), herr_t, (hid_t, H5Z_filter_t, UInt32, Csize_t, Ptr{UInt32}), plist_id, filter, flags, cd_nelmts, c_values)
end

function H5Pget_nfilters(plist_id)
    ccall((:H5Pget_nfilters, libclang), Cint, (hid_t,), plist_id)
end

function H5Pget_filter2(plist_id, filter, flags, cd_nelmts, cd_values, namelen, name, filter_config)
    ccall((:H5Pget_filter2, libclang), H5Z_filter_t, (hid_t, UInt32, Ptr{UInt32}, Ptr{Csize_t}, Ptr{UInt32}, Csize_t, Ptr{UInt8}, Ptr{UInt32}), plist_id, filter, flags, cd_nelmts, cd_values, namelen, name, filter_config)
end

function H5Pget_filter_by_id2(plist_id, id, flags, cd_nelmts, cd_values, namelen, name, filter_config)
    ccall((:H5Pget_filter_by_id2, libclang), herr_t, (hid_t, H5Z_filter_t, Ptr{UInt32}, Ptr{Csize_t}, Ptr{UInt32}, Csize_t, Ptr{UInt8}, Ptr{UInt32}), plist_id, id, flags, cd_nelmts, cd_values, namelen, name, filter_config)
end

function H5Pall_filters_avail(plist_id)
    ccall((:H5Pall_filters_avail, libclang), htri_t, (hid_t,), plist_id)
end

function H5Premove_filter(plist_id, filter)
    ccall((:H5Premove_filter, libclang), herr_t, (hid_t, H5Z_filter_t), plist_id, filter)
end

function H5Pset_deflate(plist_id, aggression)
    ccall((:H5Pset_deflate, libclang), herr_t, (hid_t, UInt32), plist_id, aggression)
end

function H5Pset_fletcher32(plist_id)
    ccall((:H5Pset_fletcher32, libclang), herr_t, (hid_t,), plist_id)
end

function H5Pget_version(plist_id, boot, freelist, stab, shhdr)
    ccall((:H5Pget_version, libclang), herr_t, (hid_t, Ptr{UInt32}, Ptr{UInt32}, Ptr{UInt32}, Ptr{UInt32}), plist_id, boot, freelist, stab, shhdr)
end

function H5Pset_userblock(plist_id, size)
    ccall((:H5Pset_userblock, libclang), herr_t, (hid_t, hsize_t), plist_id, size)
end

function H5Pget_userblock(plist_id, size)
    ccall((:H5Pget_userblock, libclang), herr_t, (hid_t, Ptr{hsize_t}), plist_id, size)
end

function H5Pset_sizes(plist_id, sizeof_addr, sizeof_size)
    ccall((:H5Pset_sizes, libclang), herr_t, (hid_t, Csize_t, Csize_t), plist_id, sizeof_addr, sizeof_size)
end

function H5Pget_sizes(plist_id, sizeof_addr, sizeof_size)
    ccall((:H5Pget_sizes, libclang), herr_t, (hid_t, Ptr{Csize_t}, Ptr{Csize_t}), plist_id, sizeof_addr, sizeof_size)
end

function H5Pset_sym_k(plist_id, ik, lk)
    ccall((:H5Pset_sym_k, libclang), herr_t, (hid_t, UInt32, UInt32), plist_id, ik, lk)
end

function H5Pget_sym_k(plist_id, ik, lk)
    ccall((:H5Pget_sym_k, libclang), herr_t, (hid_t, Ptr{UInt32}, Ptr{UInt32}), plist_id, ik, lk)
end

function H5Pset_istore_k(plist_id, ik)
    ccall((:H5Pset_istore_k, libclang), herr_t, (hid_t, UInt32), plist_id, ik)
end

function H5Pget_istore_k(plist_id, ik)
    ccall((:H5Pget_istore_k, libclang), herr_t, (hid_t, Ptr{UInt32}), plist_id, ik)
end

function H5Pset_shared_mesg_nindexes(plist_id, nindexes)
    ccall((:H5Pset_shared_mesg_nindexes, libclang), herr_t, (hid_t, UInt32), plist_id, nindexes)
end

function H5Pget_shared_mesg_nindexes(plist_id, nindexes)
    ccall((:H5Pget_shared_mesg_nindexes, libclang), herr_t, (hid_t, Ptr{UInt32}), plist_id, nindexes)
end

function H5Pset_shared_mesg_index(plist_id, index_num, mesg_type_flags, min_mesg_size)
    ccall((:H5Pset_shared_mesg_index, libclang), herr_t, (hid_t, UInt32, UInt32, UInt32), plist_id, index_num, mesg_type_flags, min_mesg_size)
end

function H5Pget_shared_mesg_index(plist_id, index_num, mesg_type_flags, min_mesg_size)
    ccall((:H5Pget_shared_mesg_index, libclang), herr_t, (hid_t, UInt32, Ptr{UInt32}, Ptr{UInt32}), plist_id, index_num, mesg_type_flags, min_mesg_size)
end

function H5Pset_shared_mesg_phase_change(plist_id, max_list, min_btree)
    ccall((:H5Pset_shared_mesg_phase_change, libclang), herr_t, (hid_t, UInt32, UInt32), plist_id, max_list, min_btree)
end

function H5Pget_shared_mesg_phase_change(plist_id, max_list, min_btree)
    ccall((:H5Pget_shared_mesg_phase_change, libclang), herr_t, (hid_t, Ptr{UInt32}, Ptr{UInt32}), plist_id, max_list, min_btree)
end

function H5Pset_alignment(fapl_id, threshold, alignment)
    ccall((:H5Pset_alignment, libclang), herr_t, (hid_t, hsize_t, hsize_t), fapl_id, threshold, alignment)
end

function H5Pget_alignment(fapl_id, threshold, alignment)
    ccall((:H5Pget_alignment, libclang), herr_t, (hid_t, Ptr{hsize_t}, Ptr{hsize_t}), fapl_id, threshold, alignment)
end

function H5Pset_driver(plist_id, driver_id, driver_info)
    ccall((:H5Pset_driver, libclang), herr_t, (hid_t, hid_t, Ptr{Cvoid}), plist_id, driver_id, driver_info)
end

function H5Pget_driver(plist_id)
    ccall((:H5Pget_driver, libclang), hid_t, (hid_t,), plist_id)
end

function H5Pget_driver_info(plist_id)
    ccall((:H5Pget_driver_info, libclang), Ptr{Cvoid}, (hid_t,), plist_id)
end

function H5Pset_family_offset(fapl_id, offset)
    ccall((:H5Pset_family_offset, libclang), herr_t, (hid_t, hsize_t), fapl_id, offset)
end

function H5Pget_family_offset(fapl_id, offset)
    ccall((:H5Pget_family_offset, libclang), herr_t, (hid_t, Ptr{hsize_t}), fapl_id, offset)
end

function H5Pset_multi_type(fapl_id, type)
    ccall((:H5Pset_multi_type, libclang), herr_t, (hid_t, H5FD_mem_t), fapl_id, type)
end

function H5Pget_multi_type(fapl_id, type)
    ccall((:H5Pget_multi_type, libclang), herr_t, (hid_t, Ptr{H5FD_mem_t}), fapl_id, type)
end

function H5Pset_cache(plist_id, mdc_nelmts, rdcc_nslots, rdcc_nbytes, rdcc_w0)
    ccall((:H5Pset_cache, libclang), herr_t, (hid_t, Cint, Csize_t, Csize_t, Cdouble), plist_id, mdc_nelmts, rdcc_nslots, rdcc_nbytes, rdcc_w0)
end

function H5Pget_cache(plist_id, mdc_nelmts, rdcc_nslots, rdcc_nbytes, rdcc_w0)
    ccall((:H5Pget_cache, libclang), herr_t, (hid_t, Ptr{Cint}, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cdouble}), plist_id, mdc_nelmts, rdcc_nslots, rdcc_nbytes, rdcc_w0)
end

function H5Pset_mdc_config(plist_id, config_ptr)
    ccall((:H5Pset_mdc_config, libclang), herr_t, (hid_t, Ptr{H5AC_cache_config_t}), plist_id, config_ptr)
end

function H5Pget_mdc_config(plist_id, config_ptr)
    ccall((:H5Pget_mdc_config, libclang), herr_t, (hid_t, Ptr{H5AC_cache_config_t}), plist_id, config_ptr)
end

function H5Pset_gc_references(fapl_id, gc_ref)
    ccall((:H5Pset_gc_references, libclang), herr_t, (hid_t, UInt32), fapl_id, gc_ref)
end

function H5Pget_gc_references(fapl_id, gc_ref)
    ccall((:H5Pget_gc_references, libclang), herr_t, (hid_t, Ptr{UInt32}), fapl_id, gc_ref)
end

function H5Pset_fclose_degree(fapl_id, degree)
    ccall((:H5Pset_fclose_degree, libclang), herr_t, (hid_t, H5F_close_degree_t), fapl_id, degree)
end

function H5Pget_fclose_degree(fapl_id, degree)
    ccall((:H5Pget_fclose_degree, libclang), herr_t, (hid_t, Ptr{H5F_close_degree_t}), fapl_id, degree)
end

function H5Pset_meta_block_size(fapl_id, size)
    ccall((:H5Pset_meta_block_size, libclang), herr_t, (hid_t, hsize_t), fapl_id, size)
end

function H5Pget_meta_block_size(fapl_id, size)
    ccall((:H5Pget_meta_block_size, libclang), herr_t, (hid_t, Ptr{hsize_t}), fapl_id, size)
end

function H5Pset_sieve_buf_size(fapl_id, size)
    ccall((:H5Pset_sieve_buf_size, libclang), herr_t, (hid_t, Csize_t), fapl_id, size)
end

function H5Pget_sieve_buf_size(fapl_id, size)
    ccall((:H5Pget_sieve_buf_size, libclang), herr_t, (hid_t, Ptr{Csize_t}), fapl_id, size)
end

function H5Pset_small_data_block_size(fapl_id, size)
    ccall((:H5Pset_small_data_block_size, libclang), herr_t, (hid_t, hsize_t), fapl_id, size)
end

function H5Pget_small_data_block_size(fapl_id, size)
    ccall((:H5Pget_small_data_block_size, libclang), herr_t, (hid_t, Ptr{hsize_t}), fapl_id, size)
end

function H5Pset_libver_bounds(plist_id, low, high)
    ccall((:H5Pset_libver_bounds, libclang), herr_t, (hid_t, H5F_libver_t, H5F_libver_t), plist_id, low, high)
end

function H5Pget_libver_bounds(plist_id, low, high)
    ccall((:H5Pget_libver_bounds, libclang), herr_t, (hid_t, Ptr{H5F_libver_t}, Ptr{H5F_libver_t}), plist_id, low, high)
end

function H5Pset_elink_file_cache_size(plist_id, efc_size)
    ccall((:H5Pset_elink_file_cache_size, libclang), herr_t, (hid_t, UInt32), plist_id, efc_size)
end

function H5Pget_elink_file_cache_size(plist_id, efc_size)
    ccall((:H5Pget_elink_file_cache_size, libclang), herr_t, (hid_t, Ptr{UInt32}), plist_id, efc_size)
end

function H5Pset_file_image(fapl_id, buf_ptr, buf_len)
    ccall((:H5Pset_file_image, libclang), herr_t, (hid_t, Ptr{Cvoid}, Csize_t), fapl_id, buf_ptr, buf_len)
end

function H5Pget_file_image(fapl_id, buf_ptr_ptr, buf_len_ptr)
    ccall((:H5Pget_file_image, libclang), herr_t, (hid_t, Ptr{Ptr{Cvoid}}, Ptr{Csize_t}), fapl_id, buf_ptr_ptr, buf_len_ptr)
end

function H5Pset_file_image_callbacks(fapl_id, callbacks_ptr)
    ccall((:H5Pset_file_image_callbacks, libclang), herr_t, (hid_t, Ptr{H5FD_file_image_callbacks_t}), fapl_id, callbacks_ptr)
end

function H5Pget_file_image_callbacks(fapl_id, callbacks_ptr)
    ccall((:H5Pget_file_image_callbacks, libclang), herr_t, (hid_t, Ptr{H5FD_file_image_callbacks_t}), fapl_id, callbacks_ptr)
end

function H5Pset_core_write_tracking(fapl_id, is_enabled, page_size)
    ccall((:H5Pset_core_write_tracking, libclang), herr_t, (hid_t, hbool_t, Csize_t), fapl_id, is_enabled, page_size)
end

function H5Pget_core_write_tracking(fapl_id, is_enabled, page_size)
    ccall((:H5Pget_core_write_tracking, libclang), herr_t, (hid_t, Ptr{hbool_t}, Ptr{Csize_t}), fapl_id, is_enabled, page_size)
end

function H5Pset_layout(plist_id, layout)
    ccall((:H5Pset_layout, libclang), herr_t, (hid_t, H5D_layout_t), plist_id, layout)
end

function H5Pget_layout(plist_id)
    ccall((:H5Pget_layout, libclang), H5D_layout_t, (hid_t,), plist_id)
end

function H5Pset_chunk(plist_id, ndims, dim)
    ccall((:H5Pset_chunk, libclang), herr_t, (hid_t, Cint, Ptr{hsize_t}), plist_id, ndims, dim)
end

function H5Pget_chunk(plist_id, max_ndims, dim)
    ccall((:H5Pget_chunk, libclang), Cint, (hid_t, Cint, Ptr{hsize_t}), plist_id, max_ndims, dim)
end

function H5Pset_external(plist_id, name, offset, size)
    ccall((:H5Pset_external, libclang), herr_t, (hid_t, Cstring, off_t, hsize_t), plist_id, name, offset, size)
end

function H5Pget_external_count(plist_id)
    ccall((:H5Pget_external_count, libclang), Cint, (hid_t,), plist_id)
end

function H5Pget_external(plist_id, idx, name_size, name, offset, size)
    ccall((:H5Pget_external, libclang), herr_t, (hid_t, UInt32, Csize_t, Cstring, Ptr{off_t}, Ptr{hsize_t}), plist_id, idx, name_size, name, offset, size)
end

function H5Pset_szip(plist_id, options_mask, pixels_per_block)
    ccall((:H5Pset_szip, libclang), herr_t, (hid_t, UInt32, UInt32), plist_id, options_mask, pixels_per_block)
end

function H5Pset_shuffle(plist_id)
    ccall((:H5Pset_shuffle, libclang), herr_t, (hid_t,), plist_id)
end

function H5Pset_nbit(plist_id)
    ccall((:H5Pset_nbit, libclang), herr_t, (hid_t,), plist_id)
end

function H5Pset_scaleoffset(plist_id, scale_type, scale_factor)
    ccall((:H5Pset_scaleoffset, libclang), herr_t, (hid_t, H5Z_SO_scale_type_t, Cint), plist_id, scale_type, scale_factor)
end

function H5Pset_fill_value(plist_id, type_id, value)
    ccall((:H5Pset_fill_value, libclang), herr_t, (hid_t, hid_t, Ptr{Cvoid}), plist_id, type_id, value)
end

function H5Pget_fill_value(plist_id, type_id, value)
    ccall((:H5Pget_fill_value, libclang), herr_t, (hid_t, hid_t, Ptr{Cvoid}), plist_id, type_id, value)
end

function H5Pfill_value_defined(plist, status)
    ccall((:H5Pfill_value_defined, libclang), herr_t, (hid_t, Ptr{H5D_fill_value_t}), plist, status)
end

function H5Pset_alloc_time(plist_id, alloc_time)
    ccall((:H5Pset_alloc_time, libclang), herr_t, (hid_t, H5D_alloc_time_t), plist_id, alloc_time)
end

function H5Pget_alloc_time(plist_id, alloc_time)
    ccall((:H5Pget_alloc_time, libclang), herr_t, (hid_t, Ptr{H5D_alloc_time_t}), plist_id, alloc_time)
end

function H5Pset_fill_time(plist_id, fill_time)
    ccall((:H5Pset_fill_time, libclang), herr_t, (hid_t, H5D_fill_time_t), plist_id, fill_time)
end

function H5Pget_fill_time(plist_id, fill_time)
    ccall((:H5Pget_fill_time, libclang), herr_t, (hid_t, Ptr{H5D_fill_time_t}), plist_id, fill_time)
end

function H5Pset_chunk_cache(dapl_id, rdcc_nslots, rdcc_nbytes, rdcc_w0)
    ccall((:H5Pset_chunk_cache, libclang), herr_t, (hid_t, Csize_t, Csize_t, Cdouble), dapl_id, rdcc_nslots, rdcc_nbytes, rdcc_w0)
end

function H5Pget_chunk_cache(dapl_id, rdcc_nslots, rdcc_nbytes, rdcc_w0)
    ccall((:H5Pget_chunk_cache, libclang), herr_t, (hid_t, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cdouble}), dapl_id, rdcc_nslots, rdcc_nbytes, rdcc_w0)
end

function H5Pset_efile_prefix(dapl_id, prefix)
    ccall((:H5Pset_efile_prefix, libclang), herr_t, (hid_t, Cstring), dapl_id, prefix)
end

function H5Pget_efile_prefix(dapl_id, prefix, size)
    ccall((:H5Pget_efile_prefix, libclang), ssize_t, (hid_t, Cstring, Csize_t), dapl_id, prefix, size)
end

function H5Pset_data_transform(plist_id, expression)
    ccall((:H5Pset_data_transform, libclang), herr_t, (hid_t, Cstring), plist_id, expression)
end

function H5Pget_data_transform(plist_id, expression, size)
    ccall((:H5Pget_data_transform, libclang), ssize_t, (hid_t, Cstring, Csize_t), plist_id, expression, size)
end

function H5Pset_buffer(plist_id, size, tconv, bkg)
    ccall((:H5Pset_buffer, libclang), herr_t, (hid_t, Csize_t, Ptr{Cvoid}, Ptr{Cvoid}), plist_id, size, tconv, bkg)
end

function H5Pget_buffer(plist_id, tconv, bkg)
    ccall((:H5Pget_buffer, libclang), Csize_t, (hid_t, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), plist_id, tconv, bkg)
end

function H5Pset_preserve(plist_id, status)
    ccall((:H5Pset_preserve, libclang), herr_t, (hid_t, hbool_t), plist_id, status)
end

function H5Pget_preserve(plist_id)
    ccall((:H5Pget_preserve, libclang), Cint, (hid_t,), plist_id)
end

function H5Pset_edc_check(plist_id, check)
    ccall((:H5Pset_edc_check, libclang), herr_t, (hid_t, H5Z_EDC_t), plist_id, check)
end

function H5Pget_edc_check(plist_id)
    ccall((:H5Pget_edc_check, libclang), H5Z_EDC_t, (hid_t,), plist_id)
end

function H5Pset_filter_callback(plist_id, func, op_data)
    ccall((:H5Pset_filter_callback, libclang), herr_t, (hid_t, H5Z_filter_func_t, Ptr{Cvoid}), plist_id, func, op_data)
end

function H5Pset_btree_ratios(plist_id, left, middle, right)
    ccall((:H5Pset_btree_ratios, libclang), herr_t, (hid_t, Cdouble, Cdouble, Cdouble), plist_id, left, middle, right)
end

function H5Pget_btree_ratios(plist_id, left, middle, right)
    ccall((:H5Pget_btree_ratios, libclang), herr_t, (hid_t, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), plist_id, left, middle, right)
end

function H5Pset_vlen_mem_manager(plist_id, alloc_func, alloc_info, free_func, free_info)
    ccall((:H5Pset_vlen_mem_manager, libclang), herr_t, (hid_t, H5MM_allocate_t, Ptr{Cvoid}, H5MM_free_t, Ptr{Cvoid}), plist_id, alloc_func, alloc_info, free_func, free_info)
end

function H5Pget_vlen_mem_manager(plist_id, alloc_func, alloc_info, free_func, free_info)
    ccall((:H5Pget_vlen_mem_manager, libclang), herr_t, (hid_t, Ptr{H5MM_allocate_t}, Ptr{Ptr{Cvoid}}, Ptr{H5MM_free_t}, Ptr{Ptr{Cvoid}}), plist_id, alloc_func, alloc_info, free_func, free_info)
end

function H5Pset_hyper_vector_size(fapl_id, size)
    ccall((:H5Pset_hyper_vector_size, libclang), herr_t, (hid_t, Csize_t), fapl_id, size)
end

function H5Pget_hyper_vector_size(fapl_id, size)
    ccall((:H5Pget_hyper_vector_size, libclang), herr_t, (hid_t, Ptr{Csize_t}), fapl_id, size)
end

function H5Pset_type_conv_cb(dxpl_id, op, operate_data)
    ccall((:H5Pset_type_conv_cb, libclang), herr_t, (hid_t, H5T_conv_except_func_t, Ptr{Cvoid}), dxpl_id, op, operate_data)
end

function H5Pget_type_conv_cb(dxpl_id, op, operate_data)
    ccall((:H5Pget_type_conv_cb, libclang), herr_t, (hid_t, Ptr{H5T_conv_except_func_t}, Ptr{Ptr{Cvoid}}), dxpl_id, op, operate_data)
end

function H5Pset_create_intermediate_group(plist_id, crt_intmd)
    ccall((:H5Pset_create_intermediate_group, libclang), herr_t, (hid_t, UInt32), plist_id, crt_intmd)
end

function H5Pget_create_intermediate_group(plist_id, crt_intmd)
    ccall((:H5Pget_create_intermediate_group, libclang), herr_t, (hid_t, Ptr{UInt32}), plist_id, crt_intmd)
end

function H5Pset_local_heap_size_hint(plist_id, size_hint)
    ccall((:H5Pset_local_heap_size_hint, libclang), herr_t, (hid_t, Csize_t), plist_id, size_hint)
end

function H5Pget_local_heap_size_hint(plist_id, size_hint)
    ccall((:H5Pget_local_heap_size_hint, libclang), herr_t, (hid_t, Ptr{Csize_t}), plist_id, size_hint)
end

function H5Pset_link_phase_change(plist_id, max_compact, min_dense)
    ccall((:H5Pset_link_phase_change, libclang), herr_t, (hid_t, UInt32, UInt32), plist_id, max_compact, min_dense)
end

function H5Pget_link_phase_change(plist_id, max_compact, min_dense)
    ccall((:H5Pget_link_phase_change, libclang), herr_t, (hid_t, Ptr{UInt32}, Ptr{UInt32}), plist_id, max_compact, min_dense)
end

function H5Pset_est_link_info(plist_id, est_num_entries, est_name_len)
    ccall((:H5Pset_est_link_info, libclang), herr_t, (hid_t, UInt32, UInt32), plist_id, est_num_entries, est_name_len)
end

function H5Pget_est_link_info(plist_id, est_num_entries, est_name_len)
    ccall((:H5Pget_est_link_info, libclang), herr_t, (hid_t, Ptr{UInt32}, Ptr{UInt32}), plist_id, est_num_entries, est_name_len)
end

function H5Pset_link_creation_order(plist_id, crt_order_flags)
    ccall((:H5Pset_link_creation_order, libclang), herr_t, (hid_t, UInt32), plist_id, crt_order_flags)
end

function H5Pget_link_creation_order(plist_id, crt_order_flags)
    ccall((:H5Pget_link_creation_order, libclang), herr_t, (hid_t, Ptr{UInt32}), plist_id, crt_order_flags)
end

function H5Pset_char_encoding(plist_id, encoding)
    ccall((:H5Pset_char_encoding, libclang), herr_t, (hid_t, H5T_cset_t), plist_id, encoding)
end

function H5Pget_char_encoding(plist_id, encoding)
    ccall((:H5Pget_char_encoding, libclang), herr_t, (hid_t, Ptr{H5T_cset_t}), plist_id, encoding)
end

function H5Pset_nlinks(plist_id, nlinks)
    ccall((:H5Pset_nlinks, libclang), herr_t, (hid_t, Csize_t), plist_id, nlinks)
end

function H5Pget_nlinks(plist_id, nlinks)
    ccall((:H5Pget_nlinks, libclang), herr_t, (hid_t, Ptr{Csize_t}), plist_id, nlinks)
end

function H5Pset_elink_prefix(plist_id, prefix)
    ccall((:H5Pset_elink_prefix, libclang), herr_t, (hid_t, Cstring), plist_id, prefix)
end

function H5Pget_elink_prefix(plist_id, prefix, size)
    ccall((:H5Pget_elink_prefix, libclang), ssize_t, (hid_t, Cstring, Csize_t), plist_id, prefix, size)
end

function H5Pget_elink_fapl(lapl_id)
    ccall((:H5Pget_elink_fapl, libclang), hid_t, (hid_t,), lapl_id)
end

function H5Pset_elink_fapl(lapl_id, fapl_id)
    ccall((:H5Pset_elink_fapl, libclang), herr_t, (hid_t, hid_t), lapl_id, fapl_id)
end

function H5Pset_elink_acc_flags(lapl_id, flags)
    ccall((:H5Pset_elink_acc_flags, libclang), herr_t, (hid_t, UInt32), lapl_id, flags)
end

function H5Pget_elink_acc_flags(lapl_id, flags)
    ccall((:H5Pget_elink_acc_flags, libclang), herr_t, (hid_t, Ptr{UInt32}), lapl_id, flags)
end

function H5Pset_elink_cb(lapl_id, func, op_data)
    ccall((:H5Pset_elink_cb, libclang), herr_t, (hid_t, H5L_elink_traverse_t, Ptr{Cvoid}), lapl_id, func, op_data)
end

function H5Pget_elink_cb(lapl_id, func, op_data)
    ccall((:H5Pget_elink_cb, libclang), herr_t, (hid_t, Ptr{H5L_elink_traverse_t}, Ptr{Ptr{Cvoid}}), lapl_id, func, op_data)
end

function H5Pset_copy_object(plist_id, crt_intmd)
    ccall((:H5Pset_copy_object, libclang), herr_t, (hid_t, UInt32), plist_id, crt_intmd)
end

function H5Pget_copy_object(plist_id, crt_intmd)
    ccall((:H5Pget_copy_object, libclang), herr_t, (hid_t, Ptr{UInt32}), plist_id, crt_intmd)
end

function H5Padd_merge_committed_dtype_path(plist_id, path)
    ccall((:H5Padd_merge_committed_dtype_path, libclang), herr_t, (hid_t, Cstring), plist_id, path)
end

function H5Pfree_merge_committed_dtype_paths(plist_id)
    ccall((:H5Pfree_merge_committed_dtype_paths, libclang), herr_t, (hid_t,), plist_id)
end

function H5Pset_mcdt_search_cb(plist_id, func, op_data)
    ccall((:H5Pset_mcdt_search_cb, libclang), herr_t, (hid_t, H5O_mcdt_search_cb_t, Ptr{Cvoid}), plist_id, func, op_data)
end

function H5Pget_mcdt_search_cb(plist_id, func, op_data)
    ccall((:H5Pget_mcdt_search_cb, libclang), herr_t, (hid_t, Ptr{H5O_mcdt_search_cb_t}, Ptr{Ptr{Cvoid}}), plist_id, func, op_data)
end

function H5Pregister1(cls_id, name, size, def_value, prp_create, prp_set, prp_get, prp_del, prp_copy, prp_close)
    ccall((:H5Pregister1, libclang), herr_t, (hid_t, Cstring, Csize_t, Ptr{Cvoid}, H5P_prp_create_func_t, H5P_prp_set_func_t, H5P_prp_get_func_t, H5P_prp_delete_func_t, H5P_prp_copy_func_t, H5P_prp_close_func_t), cls_id, name, size, def_value, prp_create, prp_set, prp_get, prp_del, prp_copy, prp_close)
end

function H5Pinsert1(plist_id, name, size, value, prp_set, prp_get, prp_delete, prp_copy, prp_close)
    ccall((:H5Pinsert1, libclang), herr_t, (hid_t, Cstring, Csize_t, Ptr{Cvoid}, H5P_prp_set_func_t, H5P_prp_get_func_t, H5P_prp_delete_func_t, H5P_prp_copy_func_t, H5P_prp_close_func_t), plist_id, name, size, value, prp_set, prp_get, prp_delete, prp_copy, prp_close)
end

function H5Pget_filter1(plist_id, filter, flags, cd_nelmts, cd_values, namelen, name)
    ccall((:H5Pget_filter1, libclang), H5Z_filter_t, (hid_t, UInt32, Ptr{UInt32}, Ptr{Csize_t}, Ptr{UInt32}, Csize_t, Ptr{UInt8}), plist_id, filter, flags, cd_nelmts, cd_values, namelen, name)
end

function H5Pget_filter_by_id1(plist_id, id, flags, cd_nelmts, cd_values, namelen, name)
    ccall((:H5Pget_filter_by_id1, libclang), herr_t, (hid_t, H5Z_filter_t, Ptr{UInt32}, Ptr{Csize_t}, Ptr{UInt32}, Csize_t, Ptr{UInt8}), plist_id, id, flags, cd_nelmts, cd_values, namelen, name)
end
# Julia wrapper for header: H5Rpublic.h
# Automatically generated using Clang.jl


function H5Rcreate(ref, loc_id, name, ref_type, space_id)
    ccall((:H5Rcreate, libclang), herr_t, (Ptr{Cvoid}, hid_t, Cstring, H5R_type_t, hid_t), ref, loc_id, name, ref_type, space_id)
end

function H5Rdereference(dataset, ref_type, ref)
    ccall((:H5Rdereference, libclang), hid_t, (hid_t, H5R_type_t, Ptr{Cvoid}), dataset, ref_type, ref)
end

function H5Rget_region(dataset, ref_type, ref)
    ccall((:H5Rget_region, libclang), hid_t, (hid_t, H5R_type_t, Ptr{Cvoid}), dataset, ref_type, ref)
end

function H5Rget_obj_type2(id, ref_type, _ref, obj_type)
    ccall((:H5Rget_obj_type2, libclang), herr_t, (hid_t, H5R_type_t, Ptr{Cvoid}, Ptr{H5O_type_t}), id, ref_type, _ref, obj_type)
end

function H5Rget_name(loc_id, ref_type, ref, name, size)
    ccall((:H5Rget_name, libclang), ssize_t, (hid_t, H5R_type_t, Ptr{Cvoid}, Cstring, Csize_t), loc_id, ref_type, ref, name, size)
end

function H5Rget_obj_type1(id, ref_type, _ref)
    ccall((:H5Rget_obj_type1, libclang), H5G_obj_t, (hid_t, H5R_type_t, Ptr{Cvoid}), id, ref_type, _ref)
end
# Julia wrapper for header: H5Spublic.h
# Automatically generated using Clang.jl


function H5Screate(type)
    ccall((:H5Screate, libclang), hid_t, (H5S_class_t,), type)
end

function H5Screate_simple(rank, dims, maxdims)
    ccall((:H5Screate_simple, libclang), hid_t, (Cint, Ptr{hsize_t}, Ptr{hsize_t}), rank, dims, maxdims)
end

function H5Sset_extent_simple(space_id, rank, dims, max)
    ccall((:H5Sset_extent_simple, libclang), herr_t, (hid_t, Cint, Ptr{hsize_t}, Ptr{hsize_t}), space_id, rank, dims, max)
end

function H5Scopy(space_id)
    ccall((:H5Scopy, libclang), hid_t, (hid_t,), space_id)
end

function H5Sclose(space_id)
    ccall((:H5Sclose, libclang), herr_t, (hid_t,), space_id)
end

function H5Sencode(obj_id, buf, nalloc)
    ccall((:H5Sencode, libclang), herr_t, (hid_t, Ptr{Cvoid}, Ptr{Csize_t}), obj_id, buf, nalloc)
end

function H5Sdecode(buf)
    ccall((:H5Sdecode, libclang), hid_t, (Ptr{Cvoid},), buf)
end

function H5Sget_simple_extent_npoints(space_id)
    ccall((:H5Sget_simple_extent_npoints, libclang), hssize_t, (hid_t,), space_id)
end

function H5Sget_simple_extent_ndims(space_id)
    ccall((:H5Sget_simple_extent_ndims, libclang), Cint, (hid_t,), space_id)
end

function H5Sget_simple_extent_dims(space_id, dims, maxdims)
    ccall((:H5Sget_simple_extent_dims, libclang), Cint, (hid_t, Ptr{hsize_t}, Ptr{hsize_t}), space_id, dims, maxdims)
end

function H5Sis_simple(space_id)
    ccall((:H5Sis_simple, libclang), htri_t, (hid_t,), space_id)
end

function H5Sget_select_npoints(spaceid)
    ccall((:H5Sget_select_npoints, libclang), hssize_t, (hid_t,), spaceid)
end

function H5Sselect_hyperslab(space_id, op, start, _stride, count, _block)
    ccall((:H5Sselect_hyperslab, libclang), herr_t, (hid_t, H5S_seloper_t, Ptr{hsize_t}, Ptr{hsize_t}, Ptr{hsize_t}, Ptr{hsize_t}), space_id, op, start, _stride, count, _block)
end

function H5Sselect_elements(space_id, op, num_elem, coord)
    ccall((:H5Sselect_elements, libclang), herr_t, (hid_t, H5S_seloper_t, Csize_t, Ptr{hsize_t}), space_id, op, num_elem, coord)
end

function H5Sget_simple_extent_type(space_id)
    ccall((:H5Sget_simple_extent_type, libclang), H5S_class_t, (hid_t,), space_id)
end

function H5Sset_extent_none(space_id)
    ccall((:H5Sset_extent_none, libclang), herr_t, (hid_t,), space_id)
end

function H5Sextent_copy(dst_id, src_id)
    ccall((:H5Sextent_copy, libclang), herr_t, (hid_t, hid_t), dst_id, src_id)
end

function H5Sextent_equal(sid1, sid2)
    ccall((:H5Sextent_equal, libclang), htri_t, (hid_t, hid_t), sid1, sid2)
end

function H5Sselect_all(spaceid)
    ccall((:H5Sselect_all, libclang), herr_t, (hid_t,), spaceid)
end

function H5Sselect_none(spaceid)
    ccall((:H5Sselect_none, libclang), herr_t, (hid_t,), spaceid)
end

function H5Soffset_simple(space_id, offset)
    ccall((:H5Soffset_simple, libclang), herr_t, (hid_t, Ptr{hssize_t}), space_id, offset)
end

function H5Sselect_valid(spaceid)
    ccall((:H5Sselect_valid, libclang), htri_t, (hid_t,), spaceid)
end

function H5Sget_select_hyper_nblocks(spaceid)
    ccall((:H5Sget_select_hyper_nblocks, libclang), hssize_t, (hid_t,), spaceid)
end

function H5Sget_select_elem_npoints(spaceid)
    ccall((:H5Sget_select_elem_npoints, libclang), hssize_t, (hid_t,), spaceid)
end

function H5Sget_select_hyper_blocklist(spaceid, startblock, numblocks, buf)
    ccall((:H5Sget_select_hyper_blocklist, libclang), herr_t, (hid_t, hsize_t, hsize_t, Ptr{hsize_t}), spaceid, startblock, numblocks, buf)
end

function H5Sget_select_elem_pointlist(spaceid, startpoint, numpoints, buf)
    ccall((:H5Sget_select_elem_pointlist, libclang), herr_t, (hid_t, hsize_t, hsize_t, Ptr{hsize_t}), spaceid, startpoint, numpoints, buf)
end

function H5Sget_select_bounds(spaceid, start, _end)
    ccall((:H5Sget_select_bounds, libclang), herr_t, (hid_t, Ptr{hsize_t}, Ptr{hsize_t}), spaceid, start, _end)
end

function H5Sget_select_type(spaceid)
    ccall((:H5Sget_select_type, libclang), H5S_sel_type, (hid_t,), spaceid)
end
# Julia wrapper for header: H5TBpublic.h
# Automatically generated using Clang.jl

# Julia wrapper for header: H5Tpublic.h
# Automatically generated using Clang.jl


function H5Tcreate(type, size)
    ccall((:H5Tcreate, libclang), hid_t, (H5T_class_t, Csize_t), type, size)
end

function H5Tcopy(type_id)
    ccall((:H5Tcopy, libclang), hid_t, (hid_t,), type_id)
end

function H5Tclose(type_id)
    ccall((:H5Tclose, libclang), herr_t, (hid_t,), type_id)
end

function H5Tequal(type1_id, type2_id)
    ccall((:H5Tequal, libclang), htri_t, (hid_t, hid_t), type1_id, type2_id)
end

function H5Tlock(type_id)
    ccall((:H5Tlock, libclang), herr_t, (hid_t,), type_id)
end

function H5Tcommit2(loc_id, name, type_id, lcpl_id, tcpl_id, tapl_id)
    ccall((:H5Tcommit2, libclang), herr_t, (hid_t, Cstring, hid_t, hid_t, hid_t, hid_t), loc_id, name, type_id, lcpl_id, tcpl_id, tapl_id)
end

function H5Topen2(loc_id, name, tapl_id)
    ccall((:H5Topen2, libclang), hid_t, (hid_t, Cstring, hid_t), loc_id, name, tapl_id)
end

function H5Tcommit_anon(loc_id, type_id, tcpl_id, tapl_id)
    ccall((:H5Tcommit_anon, libclang), herr_t, (hid_t, hid_t, hid_t, hid_t), loc_id, type_id, tcpl_id, tapl_id)
end

function H5Tget_create_plist(type_id)
    ccall((:H5Tget_create_plist, libclang), hid_t, (hid_t,), type_id)
end

function H5Tcommitted(type_id)
    ccall((:H5Tcommitted, libclang), htri_t, (hid_t,), type_id)
end

function H5Tencode(obj_id, buf, nalloc)
    ccall((:H5Tencode, libclang), herr_t, (hid_t, Ptr{Cvoid}, Ptr{Csize_t}), obj_id, buf, nalloc)
end

function H5Tdecode(buf)
    ccall((:H5Tdecode, libclang), hid_t, (Ptr{Cvoid},), buf)
end

function H5Tinsert(parent_id, name, offset, member_id)
    ccall((:H5Tinsert, libclang), herr_t, (hid_t, Cstring, Csize_t, hid_t), parent_id, name, offset, member_id)
end

function H5Tpack(type_id)
    ccall((:H5Tpack, libclang), herr_t, (hid_t,), type_id)
end

function H5Tenum_create(base_id)
    ccall((:H5Tenum_create, libclang), hid_t, (hid_t,), base_id)
end

function H5Tenum_insert(type, name, value)
    ccall((:H5Tenum_insert, libclang), herr_t, (hid_t, Cstring, Ptr{Cvoid}), type, name, value)
end

function H5Tenum_nameof(type, value, name, size)
    ccall((:H5Tenum_nameof, libclang), herr_t, (hid_t, Ptr{Cvoid}, Cstring, Csize_t), type, value, name, size)
end

function H5Tenum_valueof(type, name, value)
    ccall((:H5Tenum_valueof, libclang), herr_t, (hid_t, Cstring, Ptr{Cvoid}), type, name, value)
end

function H5Tvlen_create(base_id)
    ccall((:H5Tvlen_create, libclang), hid_t, (hid_t,), base_id)
end

function H5Tarray_create2(base_id, ndims, dim)
    ccall((:H5Tarray_create2, libclang), hid_t, (hid_t, UInt32, Ptr{hsize_t}), base_id, ndims, dim)
end

function H5Tget_array_ndims(type_id)
    ccall((:H5Tget_array_ndims, libclang), Cint, (hid_t,), type_id)
end

function H5Tget_array_dims2(type_id, dims)
    ccall((:H5Tget_array_dims2, libclang), Cint, (hid_t, Ptr{hsize_t}), type_id, dims)
end

function H5Tset_tag(type, tag)
    ccall((:H5Tset_tag, libclang), herr_t, (hid_t, Cstring), type, tag)
end

function H5Tget_tag(type)
    ccall((:H5Tget_tag, libclang), Cstring, (hid_t,), type)
end

function H5Tget_super(type)
    ccall((:H5Tget_super, libclang), hid_t, (hid_t,), type)
end

function H5Tget_class(type_id)
    ccall((:H5Tget_class, libclang), H5T_class_t, (hid_t,), type_id)
end

function H5Tdetect_class(type_id, cls)
    ccall((:H5Tdetect_class, libclang), htri_t, (hid_t, H5T_class_t), type_id, cls)
end

function H5Tget_size(type_id)
    ccall((:H5Tget_size, libclang), Csize_t, (hid_t,), type_id)
end

function H5Tget_order(type_id)
    ccall((:H5Tget_order, libclang), H5T_order_t, (hid_t,), type_id)
end

function H5Tget_precision(type_id)
    ccall((:H5Tget_precision, libclang), Csize_t, (hid_t,), type_id)
end

function H5Tget_offset(type_id)
    ccall((:H5Tget_offset, libclang), Cint, (hid_t,), type_id)
end

function H5Tget_pad(type_id, lsb, msb)
    ccall((:H5Tget_pad, libclang), herr_t, (hid_t, Ptr{H5T_pad_t}, Ptr{H5T_pad_t}), type_id, lsb, msb)
end

function H5Tget_sign(type_id)
    ccall((:H5Tget_sign, libclang), H5T_sign_t, (hid_t,), type_id)
end

function H5Tget_fields(type_id, spos, epos, esize, mpos, msize)
    ccall((:H5Tget_fields, libclang), herr_t, (hid_t, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Csize_t}), type_id, spos, epos, esize, mpos, msize)
end

function H5Tget_ebias(type_id)
    ccall((:H5Tget_ebias, libclang), Csize_t, (hid_t,), type_id)
end

function H5Tget_norm(type_id)
    ccall((:H5Tget_norm, libclang), H5T_norm_t, (hid_t,), type_id)
end

function H5Tget_inpad(type_id)
    ccall((:H5Tget_inpad, libclang), H5T_pad_t, (hid_t,), type_id)
end

function H5Tget_strpad(type_id)
    ccall((:H5Tget_strpad, libclang), H5T_str_t, (hid_t,), type_id)
end

function H5Tget_nmembers(type_id)
    ccall((:H5Tget_nmembers, libclang), Cint, (hid_t,), type_id)
end

function H5Tget_member_name(type_id, membno)
    ccall((:H5Tget_member_name, libclang), Cstring, (hid_t, UInt32), type_id, membno)
end

function H5Tget_member_index(type_id, name)
    ccall((:H5Tget_member_index, libclang), Cint, (hid_t, Cstring), type_id, name)
end

function H5Tget_member_offset(type_id, membno)
    ccall((:H5Tget_member_offset, libclang), Csize_t, (hid_t, UInt32), type_id, membno)
end

function H5Tget_member_class(type_id, membno)
    ccall((:H5Tget_member_class, libclang), H5T_class_t, (hid_t, UInt32), type_id, membno)
end

function H5Tget_member_type(type_id, membno)
    ccall((:H5Tget_member_type, libclang), hid_t, (hid_t, UInt32), type_id, membno)
end

function H5Tget_member_value(type_id, membno, value)
    ccall((:H5Tget_member_value, libclang), herr_t, (hid_t, UInt32, Ptr{Cvoid}), type_id, membno, value)
end

function H5Tget_cset(type_id)
    ccall((:H5Tget_cset, libclang), H5T_cset_t, (hid_t,), type_id)
end

function H5Tis_variable_str(type_id)
    ccall((:H5Tis_variable_str, libclang), htri_t, (hid_t,), type_id)
end

function H5Tget_native_type(type_id, direction)
    ccall((:H5Tget_native_type, libclang), hid_t, (hid_t, H5T_direction_t), type_id, direction)
end

function H5Tset_size(type_id, size)
    ccall((:H5Tset_size, libclang), herr_t, (hid_t, Csize_t), type_id, size)
end

function H5Tset_order(type_id, order)
    ccall((:H5Tset_order, libclang), herr_t, (hid_t, H5T_order_t), type_id, order)
end

function H5Tset_precision(type_id, prec)
    ccall((:H5Tset_precision, libclang), herr_t, (hid_t, Csize_t), type_id, prec)
end

function H5Tset_offset(type_id, offset)
    ccall((:H5Tset_offset, libclang), herr_t, (hid_t, Csize_t), type_id, offset)
end

function H5Tset_pad(type_id, lsb, msb)
    ccall((:H5Tset_pad, libclang), herr_t, (hid_t, H5T_pad_t, H5T_pad_t), type_id, lsb, msb)
end

function H5Tset_sign(type_id, sign)
    ccall((:H5Tset_sign, libclang), herr_t, (hid_t, H5T_sign_t), type_id, sign)
end

function H5Tset_fields(type_id, spos, epos, esize, mpos, msize)
    ccall((:H5Tset_fields, libclang), herr_t, (hid_t, Csize_t, Csize_t, Csize_t, Csize_t, Csize_t), type_id, spos, epos, esize, mpos, msize)
end

function H5Tset_ebias(type_id, ebias)
    ccall((:H5Tset_ebias, libclang), herr_t, (hid_t, Csize_t), type_id, ebias)
end

function H5Tset_norm(type_id, norm)
    ccall((:H5Tset_norm, libclang), herr_t, (hid_t, H5T_norm_t), type_id, norm)
end

function H5Tset_inpad(type_id, pad)
    ccall((:H5Tset_inpad, libclang), herr_t, (hid_t, H5T_pad_t), type_id, pad)
end

function H5Tset_cset(type_id, cset)
    ccall((:H5Tset_cset, libclang), herr_t, (hid_t, H5T_cset_t), type_id, cset)
end

function H5Tset_strpad(type_id, strpad)
    ccall((:H5Tset_strpad, libclang), herr_t, (hid_t, H5T_str_t), type_id, strpad)
end

function H5Tregister(pers, name, src_id, dst_id, func)
    ccall((:H5Tregister, libclang), herr_t, (H5T_pers_t, Cstring, hid_t, hid_t, H5T_conv_t), pers, name, src_id, dst_id, func)
end

function H5Tunregister(pers, name, src_id, dst_id, func)
    ccall((:H5Tunregister, libclang), herr_t, (H5T_pers_t, Cstring, hid_t, hid_t, H5T_conv_t), pers, name, src_id, dst_id, func)
end

function H5Tfind(src_id, dst_id, pcdata)
    ccall((:H5Tfind, libclang), H5T_conv_t, (hid_t, hid_t, Ptr{Ptr{H5T_cdata_t}}), src_id, dst_id, pcdata)
end

function H5Tcompiler_conv(src_id, dst_id)
    ccall((:H5Tcompiler_conv, libclang), htri_t, (hid_t, hid_t), src_id, dst_id)
end

function H5Tconvert(src_id, dst_id, nelmts, buf, background, plist_id)
    ccall((:H5Tconvert, libclang), herr_t, (hid_t, hid_t, Csize_t, Ptr{Cvoid}, Ptr{Cvoid}, hid_t), src_id, dst_id, nelmts, buf, background, plist_id)
end

function H5Tcommit1(loc_id, name, type_id)
    ccall((:H5Tcommit1, libclang), herr_t, (hid_t, Cstring, hid_t), loc_id, name, type_id)
end

function H5Topen1(loc_id, name)
    ccall((:H5Topen1, libclang), hid_t, (hid_t, Cstring), loc_id, name)
end

function H5Tarray_create1(base_id, ndims, dim, perm)
    ccall((:H5Tarray_create1, libclang), hid_t, (hid_t, Cint, Ptr{hsize_t}, Ptr{Cint}), base_id, ndims, dim, perm)
end

function H5Tget_array_dims1(type_id, dims, perm)
    ccall((:H5Tget_array_dims1, libclang), Cint, (hid_t, Ptr{hsize_t}, Ptr{Cint}), type_id, dims, perm)
end
# Julia wrapper for header: H5Zpublic.h
# Automatically generated using Clang.jl


function H5Zregister(cls)
    ccall((:H5Zregister, libclang), herr_t, (Ptr{Cvoid},), cls)
end

function H5Zunregister(id)
    ccall((:H5Zunregister, libclang), herr_t, (H5Z_filter_t,), id)
end

function H5Zfilter_avail(id)
    ccall((:H5Zfilter_avail, libclang), htri_t, (H5Z_filter_t,), id)
end

function H5Zget_filter_info(filter, filter_config_flags)
    ccall((:H5Zget_filter_info, libclang), herr_t, (H5Z_filter_t, Ptr{UInt32}), filter, filter_config_flags)
end
# Julia wrapper for header: H5api_adpt.h
# Automatically generated using Clang.jl

# Julia wrapper for header: H5overflow.h
# Automatically generated using Clang.jl

# Julia wrapper for header: H5pubconf.h
# Automatically generated using Clang.jl

# Julia wrapper for header: H5public.h
# Automatically generated using Clang.jl


function H5open()
    ccall((:H5open, libclang), herr_t, ())
end

function H5close()
    ccall((:H5close, libclang), herr_t, ())
end

function H5dont_atexit()
    ccall((:H5dont_atexit, libclang), herr_t, ())
end

function H5garbage_collect()
    ccall((:H5garbage_collect, libclang), herr_t, ())
end

function H5set_free_list_limits(reg_global_lim, reg_list_lim, arr_global_lim, arr_list_lim, blk_global_lim, blk_list_lim)
    ccall((:H5set_free_list_limits, libclang), herr_t, (Cint, Cint, Cint, Cint, Cint, Cint), reg_global_lim, reg_list_lim, arr_global_lim, arr_list_lim, blk_global_lim, blk_list_lim)
end

function H5get_libversion(majnum, minnum, relnum)
    ccall((:H5get_libversion, libclang), herr_t, (Ptr{UInt32}, Ptr{UInt32}, Ptr{UInt32}), majnum, minnum, relnum)
end

function H5check_version(majnum, minnum, relnum)
    ccall((:H5check_version, libclang), herr_t, (UInt32, UInt32, UInt32), majnum, minnum, relnum)
end

function H5is_library_threadsafe(is_ts)
    ccall((:H5is_library_threadsafe, libclang), herr_t, (Ptr{hbool_t},), is_ts)
end

function H5free_memory(mem)
    ccall((:H5free_memory, libclang), herr_t, (Ptr{Cvoid},), mem)
end

function H5allocate_memory(size, clear)
    ccall((:H5allocate_memory, libclang), Ptr{Cvoid}, (Csize_t, hbool_t), size, clear)
end

function H5resize_memory(mem, size)
    ccall((:H5resize_memory, libclang), Ptr{Cvoid}, (Ptr{Cvoid}, Csize_t), mem, size)
end
# Julia wrapper for header: H5version.h
# Automatically generated using Clang.jl

# Julia wrapper for header: hdf5.h
# Automatically generated using Clang.jl

# Julia wrapper for header: hdf5_hl.h
# Automatically generated using Clang.jl

