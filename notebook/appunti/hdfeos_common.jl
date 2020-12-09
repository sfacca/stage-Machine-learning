# Automatically generated using Clang.jl


const H5AC__CURR_CACHE_CONFIG_VERSION = 1
const H5AC__MAX_TRACE_FILE_NAME_LEN = 1024
const H5AC_METADATA_WRITE_STRATEGY__PROCESS_0_ONLY = 0
const H5AC_METADATA_WRITE_STRATEGY__DISTRIBUTED = 1
const hbool_t = UInt32

@cenum H5C_cache_incr_mode::UInt32 begin
    H5C_incr__off = 0
    H5C_incr__threshold = 1
end

@cenum H5C_cache_flash_incr_mode::UInt32 begin
    H5C_flash_incr__off = 0
    H5C_flash_incr__add_space = 1
end

@cenum H5C_cache_decr_mode::UInt32 begin
    H5C_decr__off = 0
    H5C_decr__threshold = 1
    H5C_decr__age_out = 2
    H5C_decr__age_out_with_threshold = 3
end


struct H5AC_cache_config_t
    version::Cint
    rpt_fcn_enabled::hbool_t
    open_trace_file::hbool_t
    close_trace_file::hbool_t
    trace_file_name::NTuple{1025, UInt8}
    evictions_enabled::hbool_t
    set_initial_size::hbool_t
    initial_size::Csize_t
    min_clean_fraction::Cdouble
    max_size::Csize_t
    min_size::Csize_t
    epoch_length::Clong
    incr_mode::H5C_cache_incr_mode
    lower_hr_threshold::Cdouble
    increment::Cdouble
    apply_max_increment::hbool_t
    max_increment::Csize_t
    flash_incr_mode::H5C_cache_flash_incr_mode
    flash_multiple::Cdouble
    flash_threshold::Cdouble
    decr_mode::H5C_cache_decr_mode
    upper_hr_threshold::Cdouble
    decrement::Cdouble
    apply_max_decrement::hbool_t
    max_decrement::Csize_t
    epochs_before_eviction::Cint
    apply_empty_reserve::hbool_t
    empty_reserve::Cdouble
    dirty_bytes_threshold::Cint
    metadata_write_strategy::Cint
end

const H5O_msg_crt_idx_t = UInt32

@cenum H5T_cset_t::Int32 begin
    H5T_CSET_ERROR = -1
    H5T_CSET_ASCII = 0
    H5T_CSET_UTF8 = 1
    H5T_CSET_RESERVED_2 = 2
    H5T_CSET_RESERVED_3 = 3
    H5T_CSET_RESERVED_4 = 4
    H5T_CSET_RESERVED_5 = 5
    H5T_CSET_RESERVED_6 = 6
    H5T_CSET_RESERVED_7 = 7
    H5T_CSET_RESERVED_8 = 8
    H5T_CSET_RESERVED_9 = 9
    H5T_CSET_RESERVED_10 = 10
    H5T_CSET_RESERVED_11 = 11
    H5T_CSET_RESERVED_12 = 12
    H5T_CSET_RESERVED_13 = 13
    H5T_CSET_RESERVED_14 = 14
    H5T_CSET_RESERVED_15 = 15
end


const hsize_t = Culonglong

struct H5A_info_t
    corder_valid::hbool_t
    corder::H5O_msg_crt_idx_t
    cset::H5T_cset_t
    data_size::hsize_t
end

const H5A_operator2_t = Ptr{Cvoid}
const H5A_operator1_t = Ptr{Cvoid}
const DIMENSION_SCALE_CLASS = "DIMENSION_SCALE"
const DIMENSION_LIST = "DIMENSION_LIST"
const REFERENCE_LIST = "REFERENCE_LIST"
const DIMENSION_LABELS = "DIMENSION_LABELS"

# Skipping Typedef: CXType_FunctionProto herr_t
# Skipping MacroDefinition: H5D_CHUNK_CACHE_NSLOTS_DEFAULT ( ( size_t ) - 1 )
# Skipping MacroDefinition: H5D_CHUNK_CACHE_NBYTES_DEFAULT ( ( size_t ) - 1 )

const H5D_CHUNK_CACHE_W0_DEFAULT = -(Float32(1.0))
const H5D_XFER_DIRECT_CHUNK_WRITE_FLAG_NAME = "direct_chunk_flag"
const H5D_XFER_DIRECT_CHUNK_WRITE_FILTERS_NAME = "direct_chunk_filters"
const H5D_XFER_DIRECT_CHUNK_WRITE_OFFSET_NAME = "direct_chunk_offset"
const H5D_XFER_DIRECT_CHUNK_WRITE_DATASIZE_NAME = "direct_chunk_datasize"
const H5D_XFER_DIRECT_CHUNK_READ_FLAG_NAME = "direct_chunk_read_flag"
const H5D_XFER_DIRECT_CHUNK_READ_OFFSET_NAME = "direct_chunk_read_offset"
const H5D_XFER_DIRECT_CHUNK_READ_FILTERS_NAME = "direct_chunk_read_filters"

@cenum H5D_layout_t::Int32 begin
    H5D_LAYOUT_ERROR = -1
    H5D_COMPACT = 0
    H5D_CONTIGUOUS = 1
    H5D_CHUNKED = 2
    H5D_NLAYOUTS = 3
end

@cenum H5D_chunk_index_t::UInt32 begin
    H5D_CHUNK_BTREE = 0
end

@cenum H5D_alloc_time_t::Int32 begin
    H5D_ALLOC_TIME_ERROR = -1
    H5D_ALLOC_TIME_DEFAULT = 0
    H5D_ALLOC_TIME_EARLY = 1
    H5D_ALLOC_TIME_LATE = 2
    H5D_ALLOC_TIME_INCR = 3
end

@cenum H5D_space_status_t::Int32 begin
    H5D_SPACE_STATUS_ERROR = -1
    H5D_SPACE_STATUS_NOT_ALLOCATED = 0
    H5D_SPACE_STATUS_PART_ALLOCATED = 1
    H5D_SPACE_STATUS_ALLOCATED = 2
end

@cenum H5D_fill_time_t::Int32 begin
    H5D_FILL_TIME_ERROR = -1
    H5D_FILL_TIME_ALLOC = 0
    H5D_FILL_TIME_NEVER = 1
    H5D_FILL_TIME_IFSET = 2
end

@cenum H5D_fill_value_t::Int32 begin
    H5D_FILL_VALUE_ERROR = -1
    H5D_FILL_VALUE_UNDEFINED = 0
    H5D_FILL_VALUE_DEFAULT = 1
    H5D_FILL_VALUE_USER_DEFINED = 2
end


const H5D_operator_t = Ptr{Cvoid}
const H5D_scatter_func_t = Ptr{Cvoid}
const H5D_gather_func_t = Ptr{Cvoid}

# Skipping MacroDefinition: H5E_DATASET ( H5OPEN H5E_DATASET_g )
# Skipping MacroDefinition: H5E_FUNC ( H5OPEN H5E_FUNC_g )
# Skipping MacroDefinition: H5E_STORAGE ( H5OPEN H5E_STORAGE_g )
# Skipping MacroDefinition: H5E_FILE ( H5OPEN H5E_FILE_g )
# Skipping MacroDefinition: H5E_SOHM ( H5OPEN H5E_SOHM_g )
# Skipping MacroDefinition: H5E_SYM ( H5OPEN H5E_SYM_g )
# Skipping MacroDefinition: H5E_PLUGIN ( H5OPEN H5E_PLUGIN_g )
# Skipping MacroDefinition: H5E_VFL ( H5OPEN H5E_VFL_g )
# Skipping MacroDefinition: H5E_INTERNAL ( H5OPEN H5E_INTERNAL_g )
# Skipping MacroDefinition: H5E_BTREE ( H5OPEN H5E_BTREE_g )
# Skipping MacroDefinition: H5E_REFERENCE ( H5OPEN H5E_REFERENCE_g )
# Skipping MacroDefinition: H5E_DATASPACE ( H5OPEN H5E_DATASPACE_g )
# Skipping MacroDefinition: H5E_RESOURCE ( H5OPEN H5E_RESOURCE_g )
# Skipping MacroDefinition: H5E_PLIST ( H5OPEN H5E_PLIST_g )
# Skipping MacroDefinition: H5E_LINK ( H5OPEN H5E_LINK_g )
# Skipping MacroDefinition: H5E_DATATYPE ( H5OPEN H5E_DATATYPE_g )
# Skipping MacroDefinition: H5E_RS ( H5OPEN H5E_RS_g )
# Skipping MacroDefinition: H5E_HEAP ( H5OPEN H5E_HEAP_g )
# Skipping MacroDefinition: H5E_OHDR ( H5OPEN H5E_OHDR_g )
# Skipping MacroDefinition: H5E_ATOM ( H5OPEN H5E_ATOM_g )
# Skipping MacroDefinition: H5E_ATTR ( H5OPEN H5E_ATTR_g )
# Skipping MacroDefinition: H5E_NONE_MAJOR ( H5OPEN H5E_NONE_MAJOR_g )
# Skipping MacroDefinition: H5E_IO ( H5OPEN H5E_IO_g )
# Skipping MacroDefinition: H5E_SLIST ( H5OPEN H5E_SLIST_g )
# Skipping MacroDefinition: H5E_EFL ( H5OPEN H5E_EFL_g )
# Skipping MacroDefinition: H5E_TST ( H5OPEN H5E_TST_g )
# Skipping MacroDefinition: H5E_ARGS ( H5OPEN H5E_ARGS_g )
# Skipping MacroDefinition: H5E_ERROR ( H5OPEN H5E_ERROR_g )
# Skipping MacroDefinition: H5E_PLINE ( H5OPEN H5E_PLINE_g )
# Skipping MacroDefinition: H5E_FSPACE ( H5OPEN H5E_FSPACE_g )
# Skipping MacroDefinition: H5E_CACHE ( H5OPEN H5E_CACHE_g )
# Skipping MacroDefinition: H5E_SEEKERROR ( H5OPEN H5E_SEEKERROR_g )
# Skipping MacroDefinition: H5E_READERROR ( H5OPEN H5E_READERROR_g )
# Skipping MacroDefinition: H5E_WRITEERROR ( H5OPEN H5E_WRITEERROR_g )
# Skipping MacroDefinition: H5E_CLOSEERROR ( H5OPEN H5E_CLOSEERROR_g )
# Skipping MacroDefinition: H5E_OVERFLOW ( H5OPEN H5E_OVERFLOW_g )
# Skipping MacroDefinition: H5E_FCNTL ( H5OPEN H5E_FCNTL_g )
# Skipping MacroDefinition: H5E_NOSPACE ( H5OPEN H5E_NOSPACE_g )
# Skipping MacroDefinition: H5E_CANTALLOC ( H5OPEN H5E_CANTALLOC_g )
# Skipping MacroDefinition: H5E_CANTCOPY ( H5OPEN H5E_CANTCOPY_g )
# Skipping MacroDefinition: H5E_CANTFREE ( H5OPEN H5E_CANTFREE_g )
# Skipping MacroDefinition: H5E_ALREADYEXISTS ( H5OPEN H5E_ALREADYEXISTS_g )
# Skipping MacroDefinition: H5E_CANTLOCK ( H5OPEN H5E_CANTLOCK_g )
# Skipping MacroDefinition: H5E_CANTUNLOCK ( H5OPEN H5E_CANTUNLOCK_g )
# Skipping MacroDefinition: H5E_CANTGC ( H5OPEN H5E_CANTGC_g )
# Skipping MacroDefinition: H5E_CANTGETSIZE ( H5OPEN H5E_CANTGETSIZE_g )
# Skipping MacroDefinition: H5E_OBJOPEN ( H5OPEN H5E_OBJOPEN_g )
# Skipping MacroDefinition: H5E_CANTRESTORE ( H5OPEN H5E_CANTRESTORE_g )
# Skipping MacroDefinition: H5E_CANTCOMPUTE ( H5OPEN H5E_CANTCOMPUTE_g )
# Skipping MacroDefinition: H5E_CANTEXTEND ( H5OPEN H5E_CANTEXTEND_g )
# Skipping MacroDefinition: H5E_CANTATTACH ( H5OPEN H5E_CANTATTACH_g )
# Skipping MacroDefinition: H5E_CANTUPDATE ( H5OPEN H5E_CANTUPDATE_g )
# Skipping MacroDefinition: H5E_CANTOPERATE ( H5OPEN H5E_CANTOPERATE_g )
# Skipping MacroDefinition: H5E_CANTINIT ( H5OPEN H5E_CANTINIT_g )
# Skipping MacroDefinition: H5E_ALREADYINIT ( H5OPEN H5E_ALREADYINIT_g )
# Skipping MacroDefinition: H5E_CANTRELEASE ( H5OPEN H5E_CANTRELEASE_g )
# Skipping MacroDefinition: H5E_CANTGET ( H5OPEN H5E_CANTGET_g )
# Skipping MacroDefinition: H5E_CANTSET ( H5OPEN H5E_CANTSET_g )
# Skipping MacroDefinition: H5E_DUPCLASS ( H5OPEN H5E_DUPCLASS_g )
# Skipping MacroDefinition: H5E_SETDISALLOWED ( H5OPEN H5E_SETDISALLOWED_g )
# Skipping MacroDefinition: H5E_CANTMERGE ( H5OPEN H5E_CANTMERGE_g )
# Skipping MacroDefinition: H5E_CANTREVIVE ( H5OPEN H5E_CANTREVIVE_g )
# Skipping MacroDefinition: H5E_CANTSHRINK ( H5OPEN H5E_CANTSHRINK_g )
# Skipping MacroDefinition: H5E_LINKCOUNT ( H5OPEN H5E_LINKCOUNT_g )
# Skipping MacroDefinition: H5E_VERSION ( H5OPEN H5E_VERSION_g )
# Skipping MacroDefinition: H5E_ALIGNMENT ( H5OPEN H5E_ALIGNMENT_g )
# Skipping MacroDefinition: H5E_BADMESG ( H5OPEN H5E_BADMESG_g )
# Skipping MacroDefinition: H5E_CANTDELETE ( H5OPEN H5E_CANTDELETE_g )
# Skipping MacroDefinition: H5E_BADITER ( H5OPEN H5E_BADITER_g )
# Skipping MacroDefinition: H5E_CANTPACK ( H5OPEN H5E_CANTPACK_g )
# Skipping MacroDefinition: H5E_CANTRESET ( H5OPEN H5E_CANTRESET_g )
# Skipping MacroDefinition: H5E_CANTRENAME ( H5OPEN H5E_CANTRENAME_g )
# Skipping MacroDefinition: H5E_SYSERRSTR ( H5OPEN H5E_SYSERRSTR_g )
# Skipping MacroDefinition: H5E_NOFILTER ( H5OPEN H5E_NOFILTER_g )
# Skipping MacroDefinition: H5E_CALLBACK ( H5OPEN H5E_CALLBACK_g )
# Skipping MacroDefinition: H5E_CANAPPLY ( H5OPEN H5E_CANAPPLY_g )
# Skipping MacroDefinition: H5E_SETLOCAL ( H5OPEN H5E_SETLOCAL_g )
# Skipping MacroDefinition: H5E_NOENCODER ( H5OPEN H5E_NOENCODER_g )
# Skipping MacroDefinition: H5E_CANTFILTER ( H5OPEN H5E_CANTFILTER_g )
# Skipping MacroDefinition: H5E_CANTOPENOBJ ( H5OPEN H5E_CANTOPENOBJ_g )
# Skipping MacroDefinition: H5E_CANTCLOSEOBJ ( H5OPEN H5E_CANTCLOSEOBJ_g )
# Skipping MacroDefinition: H5E_COMPLEN ( H5OPEN H5E_COMPLEN_g )
# Skipping MacroDefinition: H5E_PATH ( H5OPEN H5E_PATH_g )
# Skipping MacroDefinition: H5E_NONE_MINOR ( H5OPEN H5E_NONE_MINOR_g )
# Skipping MacroDefinition: H5E_OPENERROR ( H5OPEN H5E_OPENERROR_g )
# Skipping MacroDefinition: H5E_FILEEXISTS ( H5OPEN H5E_FILEEXISTS_g )
# Skipping MacroDefinition: H5E_FILEOPEN ( H5OPEN H5E_FILEOPEN_g )
# Skipping MacroDefinition: H5E_CANTCREATE ( H5OPEN H5E_CANTCREATE_g )
# Skipping MacroDefinition: H5E_CANTOPENFILE ( H5OPEN H5E_CANTOPENFILE_g )
# Skipping MacroDefinition: H5E_CANTCLOSEFILE ( H5OPEN H5E_CANTCLOSEFILE_g )
# Skipping MacroDefinition: H5E_NOTHDF5 ( H5OPEN H5E_NOTHDF5_g )
# Skipping MacroDefinition: H5E_BADFILE ( H5OPEN H5E_BADFILE_g )
# Skipping MacroDefinition: H5E_TRUNCATED ( H5OPEN H5E_TRUNCATED_g )
# Skipping MacroDefinition: H5E_MOUNT ( H5OPEN H5E_MOUNT_g )
# Skipping MacroDefinition: H5E_BADATOM ( H5OPEN H5E_BADATOM_g )
# Skipping MacroDefinition: H5E_BADGROUP ( H5OPEN H5E_BADGROUP_g )
# Skipping MacroDefinition: H5E_CANTREGISTER ( H5OPEN H5E_CANTREGISTER_g )
# Skipping MacroDefinition: H5E_CANTINC ( H5OPEN H5E_CANTINC_g )
# Skipping MacroDefinition: H5E_CANTDEC ( H5OPEN H5E_CANTDEC_g )
# Skipping MacroDefinition: H5E_NOIDS ( H5OPEN H5E_NOIDS_g )
# Skipping MacroDefinition: H5E_CANTFLUSH ( H5OPEN H5E_CANTFLUSH_g )
# Skipping MacroDefinition: H5E_CANTSERIALIZE ( H5OPEN H5E_CANTSERIALIZE_g )
# Skipping MacroDefinition: H5E_CANTLOAD ( H5OPEN H5E_CANTLOAD_g )
# Skipping MacroDefinition: H5E_PROTECT ( H5OPEN H5E_PROTECT_g )
# Skipping MacroDefinition: H5E_NOTCACHED ( H5OPEN H5E_NOTCACHED_g )
# Skipping MacroDefinition: H5E_SYSTEM ( H5OPEN H5E_SYSTEM_g )
# Skipping MacroDefinition: H5E_CANTINS ( H5OPEN H5E_CANTINS_g )
# Skipping MacroDefinition: H5E_CANTPROTECT ( H5OPEN H5E_CANTPROTECT_g )
# Skipping MacroDefinition: H5E_CANTUNPROTECT ( H5OPEN H5E_CANTUNPROTECT_g )
# Skipping MacroDefinition: H5E_CANTPIN ( H5OPEN H5E_CANTPIN_g )
# Skipping MacroDefinition: H5E_CANTUNPIN ( H5OPEN H5E_CANTUNPIN_g )
# Skipping MacroDefinition: H5E_CANTMARKDIRTY ( H5OPEN H5E_CANTMARKDIRTY_g )
# Skipping MacroDefinition: H5E_CANTDIRTY ( H5OPEN H5E_CANTDIRTY_g )
# Skipping MacroDefinition: H5E_CANTEXPUNGE ( H5OPEN H5E_CANTEXPUNGE_g )
# Skipping MacroDefinition: H5E_CANTRESIZE ( H5OPEN H5E_CANTRESIZE_g )
# Skipping MacroDefinition: H5E_TRAVERSE ( H5OPEN H5E_TRAVERSE_g )
# Skipping MacroDefinition: H5E_NLINKS ( H5OPEN H5E_NLINKS_g )
# Skipping MacroDefinition: H5E_NOTREGISTERED ( H5OPEN H5E_NOTREGISTERED_g )
# Skipping MacroDefinition: H5E_CANTMOVE ( H5OPEN H5E_CANTMOVE_g )
# Skipping MacroDefinition: H5E_CANTSORT ( H5OPEN H5E_CANTSORT_g )
# Skipping MacroDefinition: H5E_MPI ( H5OPEN H5E_MPI_g )
# Skipping MacroDefinition: H5E_MPIERRSTR ( H5OPEN H5E_MPIERRSTR_g )
# Skipping MacroDefinition: H5E_CANTRECV ( H5OPEN H5E_CANTRECV_g )
# Skipping MacroDefinition: H5E_CANTCLIP ( H5OPEN H5E_CANTCLIP_g )
# Skipping MacroDefinition: H5E_CANTCOUNT ( H5OPEN H5E_CANTCOUNT_g )
# Skipping MacroDefinition: H5E_CANTSELECT ( H5OPEN H5E_CANTSELECT_g )
# Skipping MacroDefinition: H5E_CANTNEXT ( H5OPEN H5E_CANTNEXT_g )
# Skipping MacroDefinition: H5E_BADSELECT ( H5OPEN H5E_BADSELECT_g )
# Skipping MacroDefinition: H5E_CANTCOMPARE ( H5OPEN H5E_CANTCOMPARE_g )
# Skipping MacroDefinition: H5E_UNINITIALIZED ( H5OPEN H5E_UNINITIALIZED_g )
# Skipping MacroDefinition: H5E_UNSUPPORTED ( H5OPEN H5E_UNSUPPORTED_g )
# Skipping MacroDefinition: H5E_BADTYPE ( H5OPEN H5E_BADTYPE_g )
# Skipping MacroDefinition: H5E_BADRANGE ( H5OPEN H5E_BADRANGE_g )
# Skipping MacroDefinition: H5E_BADVALUE ( H5OPEN H5E_BADVALUE_g )
# Skipping MacroDefinition: H5E_NOTFOUND ( H5OPEN H5E_NOTFOUND_g )
# Skipping MacroDefinition: H5E_EXISTS ( H5OPEN H5E_EXISTS_g )
# Skipping MacroDefinition: H5E_CANTENCODE ( H5OPEN H5E_CANTENCODE_g )
# Skipping MacroDefinition: H5E_CANTDECODE ( H5OPEN H5E_CANTDECODE_g )
# Skipping MacroDefinition: H5E_CANTSPLIT ( H5OPEN H5E_CANTSPLIT_g )
# Skipping MacroDefinition: H5E_CANTREDISTRIBUTE ( H5OPEN H5E_CANTREDISTRIBUTE_g )
# Skipping MacroDefinition: H5E_CANTSWAP ( H5OPEN H5E_CANTSWAP_g )
# Skipping MacroDefinition: H5E_CANTINSERT ( H5OPEN H5E_CANTINSERT_g )
# Skipping MacroDefinition: H5E_CANTLIST ( H5OPEN H5E_CANTLIST_g )
# Skipping MacroDefinition: H5E_CANTMODIFY ( H5OPEN H5E_CANTMODIFY_g )
# Skipping MacroDefinition: H5E_CANTREMOVE ( H5OPEN H5E_CANTREMOVE_g )
# Skipping MacroDefinition: H5E_CANTCONVERT ( H5OPEN H5E_CANTCONVERT_g )
# Skipping MacroDefinition: H5E_BADSIZE ( H5OPEN H5E_BADSIZE_g )
# Skipping MacroDefinition: H5E_DEFAULT ( hid_t ) 0
# Skipping MacroDefinition: H5OPEN H5open ( ) ,
# Skipping MacroDefinition: H5E_ERR_CLS ( H5OPEN H5E_ERR_CLS_g )
# Skipping MacroDefinition: H5E_BEGIN_TRY { unsigned H5E_saved_is_v2 ; union { H5E_auto1_t efunc1 ; H5E_auto2_t efunc2 ; } H5E_saved ; void * H5E_saved_edata ; ( void ) H5Eauto_is_v2 ( H5E_DEFAULT , & H5E_saved_is_v2 ) ; if ( H5E_saved_is_v2 ) { ( void ) H5Eget_auto2 ( H5E_DEFAULT , & H5E_saved . efunc2 , & H5E_saved_edata ) ; ( void ) H5Eset_auto2 ( H5E_DEFAULT , NULL , NULL ) ; } else { ( void ) H5Eget_auto1 ( & H5E_saved . efunc1 , & H5E_saved_edata ) ; ( void ) H5Eset_auto1 ( NULL , NULL ) ; }
# Skipping MacroDefinition: H5E_END_TRY if ( H5E_saved_is_v2 ) ( void ) H5Eset_auto2 ( H5E_DEFAULT , H5E_saved . efunc2 , H5E_saved_edata ) ; else ( void ) H5Eset_auto1 ( H5E_saved . efunc1 , H5E_saved_edata ) ; \#
}
# Skipping MacroDefinition: H5Epush_sim ( func , cls , maj , min , str ) H5Epush2 ( H5E_DEFAULT , __FILE__ , func , __LINE__ , cls , maj , min , str )
# Skipping MacroDefinition: H5Epush_ret ( func , cls , maj , min , str , ret ) { H5Epush2 ( H5E_DEFAULT , __FILE__ , func , __LINE__ , cls , maj , min , str ) ; return ( ret ) ; \
#}
# Skipping MacroDefinition: H5Epush_goto ( func , cls , maj , min , str , label ) { H5Epush2 ( H5E_DEFAULT , __FILE__ , func , __LINE__ , cls , maj , min , str ) ; goto label ; \
#}

@cenum H5E_type_t::UInt32 begin
    H5E_MAJOR = 0
    H5E_MINOR = 1
end


const hid_t = Cint

struct H5E_error2_t
    cls_id::hid_t
    maj_num::hid_t
    min_num::hid_t
    line::UInt32
    func_name::Cstring
    file_name::Cstring
    desc::Cstring
end

@cenum H5E_direction_t::UInt32 begin
    H5E_WALK_UPWARD = 0
    H5E_WALK_DOWNWARD = 1
end


const H5E_walk2_t = Ptr{Cvoid}
const H5E_auto2_t = Ptr{Cvoid}
const H5E_major_t = hid_t
const H5E_minor_t = hid_t

struct H5E_error1_t
    maj_num::H5E_major_t
    min_num::H5E_minor_t
    func_name::Cstring
    file_name::Cstring
    line::UInt32
    desc::Cstring
end

const H5E_walk1_t = Ptr{Cvoid}
const H5E_auto1_t = Ptr{Cvoid}

# Skipping MacroDefinition: H5FD_CORE ( H5FD_core_init ( ) )

const H5FD_DIRECT = -1

# Skipping MacroDefinition: H5FD_FAMILY ( H5FD_family_init ( ) )
# Skipping MacroDefinition: H5FD_LOG ( H5FD_log_init ( ) )

const H5FD_LOG_LOC_READ = 0x00000001
const H5FD_LOG_LOC_WRITE = 0x00000002
const H5FD_LOG_LOC_SEEK = 0x00000004
const H5FD_LOG_LOC_IO = (H5FD_LOG_LOC_READ | H5FD_LOG_LOC_WRITE) | H5FD_LOG_LOC_SEEK
const H5FD_LOG_FILE_READ = 0x00000008
const H5FD_LOG_FILE_WRITE = 0x00000010
const H5FD_LOG_FILE_IO = H5FD_LOG_FILE_READ | H5FD_LOG_FILE_WRITE
const H5FD_LOG_FLAVOR = 0x00000020
const H5FD_LOG_NUM_READ = 0x00000040
const H5FD_LOG_NUM_WRITE = 0x00000080
const H5FD_LOG_NUM_SEEK = 0x00000100
const H5FD_LOG_NUM_TRUNCATE = 0x00000200
const H5FD_LOG_NUM_IO = ((H5FD_LOG_NUM_READ | H5FD_LOG_NUM_WRITE) | H5FD_LOG_NUM_SEEK) | H5FD_LOG_NUM_TRUNCATE
const H5FD_LOG_TIME_OPEN = 0x00000400
const H5FD_LOG_TIME_STAT = 0x00000800
const H5FD_LOG_TIME_READ = 0x00001000
const H5FD_LOG_TIME_WRITE = 0x00002000
const H5FD_LOG_TIME_SEEK = 0x00004000
const H5FD_LOG_TIME_CLOSE = 0x00008000
const H5FD_LOG_TIME_IO = ((((H5FD_LOG_TIME_OPEN | H5FD_LOG_TIME_STAT) | H5FD_LOG_TIME_READ) | H5FD_LOG_TIME_WRITE) | H5FD_LOG_TIME_SEEK) | H5FD_LOG_TIME_CLOSE
const H5FD_LOG_ALLOC = 0x00010000
const H5FD_LOG_ALL = ((((H5FD_LOG_ALLOC | H5FD_LOG_TIME_IO) | H5FD_LOG_NUM_IO) | H5FD_LOG_FLAVOR) | H5FD_LOG_FILE_IO) | H5FD_LOG_LOC_IO
const H5D_ONE_LINK_CHUNK_IO_THRESHOLD = 0
const H5D_MULTI_CHUNK_IO_COL_THRESHOLD = 60

@cenum H5FD_mpio_xfer_t::UInt32 begin
    H5FD_MPIO_INDEPENDENT = 0
    H5FD_MPIO_COLLECTIVE = 1
end

@cenum H5FD_mpio_chunk_opt_t::UInt32 begin
    H5FD_MPIO_CHUNK_DEFAULT = 0
    H5FD_MPIO_CHUNK_ONE_IO = 1
    H5FD_MPIO_CHUNK_MULTI_IO = 2
end

@cenum H5FD_mpio_collective_opt_t::UInt32 begin
    H5FD_MPIO_COLLECTIVE_IO = 0
    H5FD_MPIO_INDIVIDUAL_IO = 1
end


const H5FD_MPIO = -1

# Skipping MacroDefinition: H5FD_MULTI ( H5FD_multi_init ( ) )

const H5_HAVE_VFL = 1
const H5FD_VFD_DEFAULT = 0

@cenum H5F_mem_t::Int32 begin
    H5FD_MEM_NOLIST = -1
    H5FD_MEM_DEFAULT = 0
    H5FD_MEM_SUPER = 1
    H5FD_MEM_BTREE = 2
    H5FD_MEM_DRAW = 3
    H5FD_MEM_GHEAP = 4
    H5FD_MEM_LHEAP = 5
    H5FD_MEM_OHDR = 6
    H5FD_MEM_NTYPES = 7
end


const H5FD_MEM_FHEAP_HDR = H5FD_MEM_OHDR
const H5FD_MEM_FHEAP_IBLOCK = H5FD_MEM_OHDR
const H5FD_MEM_FHEAP_DBLOCK = H5FD_MEM_LHEAP
const H5FD_MEM_FHEAP_HUGE_OBJ = H5FD_MEM_DRAW
const H5FD_MEM_FSPACE_HDR = H5FD_MEM_OHDR
const H5FD_MEM_FSPACE_SINFO = H5FD_MEM_LHEAP
const H5FD_MEM_SOHM_TABLE = H5FD_MEM_OHDR
const H5FD_MEM_SOHM_INDEX = H5FD_MEM_BTREE

# Skipping MacroDefinition: H5FD_FLMAP_SINGLE { H5FD_MEM_SUPER , /*default*/ H5FD_MEM_SUPER , /*super*/ H5FD_MEM_SUPER , /*btree*/ H5FD_MEM_SUPER , /*draw*/ H5FD_MEM_SUPER , /*gheap*/ H5FD_MEM_SUPER , /*lheap*/ H5FD_MEM_SUPER /*ohdr*/ \#
}
# Skipping MacroDefinition: H5FD_FLMAP_DICHOTOMY { H5FD_MEM_SUPER , /*default*/ H5FD_MEM_SUPER , /*super*/ H5FD_MEM_SUPER , /*btree*/ H5FD_MEM_DRAW , /*draw*/ H5FD_MEM_DRAW , /*gheap*/ H5FD_MEM_SUPER , /*lheap*/ H5FD_MEM_SUPER /*ohdr*/ \#
}
# Skipping MacroDefinition: H5FD_FLMAP_DEFAULT { H5FD_MEM_DEFAULT , /*default*/ H5FD_MEM_DEFAULT , /*super*/ H5FD_MEM_DEFAULT , /*btree*/ H5FD_MEM_DEFAULT , /*draw*/ H5FD_MEM_DEFAULT , /*gheap*/ H5FD_MEM_DEFAULT , /*lheap*/ H5FD_MEM_DEFAULT /*ohdr*/ \#
}

const H5FD_FEAT_AGGREGATE_METADATA = 0x00000001
const H5FD_FEAT_ACCUMULATE_METADATA_WRITE = 0x00000002
const H5FD_FEAT_ACCUMULATE_METADATA_READ = 0x00000004
const H5FD_FEAT_ACCUMULATE_METADATA = H5FD_FEAT_ACCUMULATE_METADATA_WRITE | H5FD_FEAT_ACCUMULATE_METADATA_READ
const H5FD_FEAT_DATA_SIEVE = 0x00000008
const H5FD_FEAT_AGGREGATE_SMALLDATA = 0x00000010
const H5FD_FEAT_IGNORE_DRVRINFO = 0x00000020
const H5FD_FEAT_DIRTY_SBLK_LOAD = 0x00000040
const H5FD_FEAT_POSIX_COMPAT_HANDLE = 0x00000080
const H5FD_FEAT_HAS_MPI = 0x00000100
const H5FD_FEAT_ALLOCATE_EARLY = 0x00000200
const H5FD_FEAT_ALLOW_FILE_IMAGE = 0x00000400
const H5FD_FEAT_CAN_USE_FILE_IMAGE_CALLBACKS = 0x00000800
const H5FD_mem_t = H5F_mem_t
const haddr_t = UInt64

@cenum H5F_close_degree_t::UInt32 begin
    H5F_CLOSE_DEFAULT = 0
    H5F_CLOSE_WEAK = 1
    H5F_CLOSE_SEMI = 2
    H5F_CLOSE_STRONG = 3
end


struct H5FD_class_t
    name::Cstring
    maxaddr::haddr_t
    fc_degree::H5F_close_degree_t
    sb_size::Ptr{Cvoid}
    sb_encode::Ptr{Cvoid}
    sb_decode::Ptr{Cvoid}
    fapl_size::Csize_t
    fapl_get::Ptr{Cvoid}
    fapl_copy::Ptr{Cvoid}
    fapl_free::Ptr{Cvoid}
    dxpl_size::Csize_t
    dxpl_copy::Ptr{Cvoid}
    dxpl_free::Ptr{Cvoid}
    open::Ptr{Cvoid}
    close::Ptr{Cvoid}
    cmp::Ptr{Cvoid}
    query::Ptr{Cvoid}
    get_type_map::Ptr{Cvoid}
    alloc::Ptr{Cvoid}
    free::Ptr{Cvoid}
    get_eoa::Ptr{Cvoid}
    set_eoa::Ptr{Cvoid}
    get_eof::Ptr{Cvoid}
    get_handle::Ptr{Cvoid}
    read::Ptr{Cvoid}
    write::Ptr{Cvoid}
    flush::Ptr{Cvoid}
    truncate::Ptr{Cvoid}
    lock::Ptr{Cvoid}
    unlock::Ptr{Cvoid}
    fl_map::NTuple{7, H5FD_mem_t}
end

struct H5FD_t
    driver_id::hid_t
    cls::Ptr{H5FD_class_t}
    fileno::Culong
    feature_flags::Culong
    maxaddr::haddr_t
    base_addr::haddr_t
    threshold::hsize_t
    alignment::hsize_t
end

struct H5FD_free_t
    addr::haddr_t
    size::hsize_t
    next::Ptr{H5FD_free_t}
end

@cenum H5FD_file_image_op_t::UInt32 begin
    H5FD_FILE_IMAGE_OP_NO_OP = 0
    H5FD_FILE_IMAGE_OP_PROPERTY_LIST_SET = 1
    H5FD_FILE_IMAGE_OP_PROPERTY_LIST_COPY = 2
    H5FD_FILE_IMAGE_OP_PROPERTY_LIST_GET = 3
    H5FD_FILE_IMAGE_OP_PROPERTY_LIST_CLOSE = 4
    H5FD_FILE_IMAGE_OP_FILE_OPEN = 5
    H5FD_FILE_IMAGE_OP_FILE_RESIZE = 6
    H5FD_FILE_IMAGE_OP_FILE_CLOSE = 7
end


struct H5FD_file_image_callbacks_t
    image_malloc::Ptr{Cvoid}
    image_memcpy::Ptr{Cvoid}
    image_realloc::Ptr{Cvoid}
    image_free::Ptr{Cvoid}
    udata_copy::Ptr{Cvoid}
    udata_free::Ptr{Cvoid}
    udata::Ptr{Cvoid}
end

# Skipping MacroDefinition: H5FD_SEC2 ( H5FD_sec2_init ( ) )
# Skipping MacroDefinition: H5FD_STDIO ( H5FD_stdio_init ( ) )
# Skipping MacroDefinition: H5CHECK H5check ( ) ,
# Skipping MacroDefinition: H5F_ACC_RDONLY ( H5CHECK 0x0000u )
# Skipping MacroDefinition: H5F_ACC_RDWR ( H5CHECK 0x0001u )
# Skipping MacroDefinition: H5F_ACC_TRUNC ( H5CHECK 0x0002u )
# Skipping MacroDefinition: H5F_ACC_EXCL ( H5CHECK 0x0004u )
# Skipping MacroDefinition: H5F_ACC_DEBUG ( H5CHECK 0x0000u )
# Skipping MacroDefinition: H5F_ACC_CREAT ( H5CHECK 0x0010u )
# Skipping MacroDefinition: H5F_ACC_DEFAULT ( H5CHECK 0xffffu )

const H5F_OBJ_FILE = UInt32(0x0001)
const H5F_OBJ_DATASET = UInt32(0x0002)
const H5F_OBJ_GROUP = UInt32(0x0004)
const H5F_OBJ_DATATYPE = UInt32(0x0008)
const H5F_OBJ_ATTR = UInt32(0x0010)
const H5F_OBJ_ALL = (((H5F_OBJ_FILE | H5F_OBJ_DATASET) | H5F_OBJ_GROUP) | H5F_OBJ_DATATYPE) | H5F_OBJ_ATTR
const H5F_OBJ_LOCAL = UInt32(0x0020)

# Skipping MacroDefinition: H5F_FAMILY_DEFAULT ( hsize_t ) 0
# Skipping MacroDefinition: H5F_UNLIMITED ( ( hsize_t ) ( - 1L ) )

@cenum H5F_libver_t::UInt32 begin
    H5F_LIBVER_EARLIEST = 0
    H5F_LIBVER_LATEST = 1
end


const H5F_LIBVER_18 = H5F_LIBVER_LATEST

@cenum H5F_scope_t::UInt32 begin
    H5F_SCOPE_LOCAL = 0
    H5F_SCOPE_GLOBAL = 1
end


struct H5_ih_info_t
    index_size::hsize_t
    heap_size::hsize_t
end

struct ANONYMOUS1_sohm
    hdr_size::hsize_t
    msgs_info::H5_ih_info_t
end

struct H5F_info_t
    super_ext_size::hsize_t
    sohm::ANONYMOUS1_sohm
end

const H5G_SAME_LOC = H5L_SAME_LOC

@cenum H5L_type_t::Int32 begin
    H5L_TYPE_ERROR = -1
    H5L_TYPE_HARD = 0
    H5L_TYPE_SOFT = 1
    H5L_TYPE_EXTERNAL = 64
    H5L_TYPE_MAX = 255
end


const H5G_LINK_ERROR = H5L_TYPE_ERROR
const H5G_LINK_HARD = H5L_TYPE_HARD
const H5G_LINK_SOFT = H5L_TYPE_SOFT
const H5G_link_t = H5L_type_t
const H5G_NTYPES = 256
const H5G_NLIBTYPES = 8
const H5G_NUSERTYPES = H5G_NTYPES - H5G_NLIBTYPES

# Skipping MacroDefinition: H5G_USERTYPE ( X ) ( 8 + ( X ) )

@cenum H5G_storage_type_t::Int32 begin
    H5G_STORAGE_TYPE_UNKNOWN = -1
    H5G_STORAGE_TYPE_SYMBOL_TABLE = 0
    H5G_STORAGE_TYPE_COMPACT = 1
    H5G_STORAGE_TYPE_DENSE = 2
end


struct H5G_info_t
    storage_type::H5G_storage_type_t
    nlinks::hsize_t
    max_corder::Int64
    mounted::hbool_t
end

@cenum H5G_obj_t::Int32 begin
    H5G_UNKNOWN = -1
    H5G_GROUP = 0
    H5G_DATASET = 1
    H5G_TYPE = 2
    H5G_LINK = 3
    H5G_UDLINK = 4
    H5G_RESERVED_5 = 5
    H5G_RESERVED_6 = 6
    H5G_RESERVED_7 = 7
end


const H5G_iterate_t = Ptr{Cvoid}

struct H5O_stat_t
    size::hsize_t
    free::hsize_t
    nmesgs::UInt32
    nchunks::UInt32
end

struct H5G_stat_t
    fileno::NTuple{2, Culong}
    objno::NTuple{2, Culong}
    nlink::UInt32
    type::H5G_obj_t
    mtime::Ctime_t
    linklen::Csize_t
    ohdr::H5O_stat_t
end

const H5_SIZEOF_INT = 4
const H5_SIZEOF_HID_T = H5_SIZEOF_INT
const H5I_INVALID_HID = -1

@cenum H5I_type_t::Int32 begin
    H5I_UNINIT = -2
    H5I_BADID = -1
    H5I_FILE = 1
    H5I_GROUP = 2
    H5I_DATATYPE = 3
    H5I_DATASPACE = 4
    H5I_DATASET = 5
    H5I_ATTR = 6
    H5I_REFERENCE = 7
    H5I_VFL = 8
    H5I_GENPROP_CLS = 9
    H5I_GENPROP_LST = 10
    H5I_ERROR_CLASS = 11
    H5I_ERROR_MSG = 12
    H5I_ERROR_STACK = 13
    H5I_NTYPES = 14
end


const H5I_free_t = Ptr{Cvoid}
const H5I_search_func_t = Ptr{Cvoid}
const H5LT_FILE_IMAGE_OPEN_RW = 0x0001
const H5LT_FILE_IMAGE_DONT_COPY = 0x0002
const H5LT_FILE_IMAGE_DONT_RELEASE = 0x0004
const H5LT_FILE_IMAGE_ALL = 0x0007

@cenum H5LT_lang_t::Int32 begin
    H5LT_LANG_ERR = -1
    H5LT_DDL = 0
    H5LT_C = 1
    H5LT_FORTRAN = 2
    H5LT_NO_LANG = 3
end


# Skipping MacroDefinition: H5L_MAX_LINK_NAME_LEN ( ( uint32_t ) ( - 1 ) )
# Skipping MacroDefinition: H5L_SAME_LOC ( hid_t ) 0

const H5L_LINK_CLASS_T_VERS = 0
const H5L_TYPE_BUILTIN_MAX = H5L_TYPE_SOFT
const H5L_TYPE_UD_MIN = H5L_TYPE_EXTERNAL

struct ANONYMOUS2_u
    address::haddr_t
end

struct H5L_info_t
    type::H5L_type_t
    corder_valid::hbool_t
    corder::Int64
    cset::H5T_cset_t
    u::ANONYMOUS2_u
end

const H5L_create_func_t = Ptr{Cvoid}
const H5L_move_func_t = Ptr{Cvoid}
const H5L_copy_func_t = Ptr{Cvoid}
const H5L_traverse_func_t = Ptr{Cvoid}
const H5L_delete_func_t = Ptr{Cvoid}
const H5L_query_func_t = Ptr{Cvoid}

struct H5L_class_t
    version::Cint
    id::H5L_type_t
    comment::Cstring
    create_func::H5L_create_func_t
    move_func::H5L_move_func_t
    copy_func::H5L_copy_func_t
    trav_func::H5L_traverse_func_t
    del_func::H5L_delete_func_t
    query_func::H5L_query_func_t
end

const H5L_iterate_t = Ptr{Cvoid}
const H5L_elink_traverse_t = Ptr{Cvoid}
const H5MM_allocate_t = Ptr{Cvoid}
const H5MM_free_t = Ptr{Cvoid}
const H5O_COPY_SHALLOW_HIERARCHY_FLAG = UInt32(0x0001)
const H5O_COPY_EXPAND_SOFT_LINK_FLAG = UInt32(0x0002)
const H5O_COPY_EXPAND_EXT_LINK_FLAG = UInt32(0x0004)
const H5O_COPY_EXPAND_REFERENCE_FLAG = UInt32(0x0008)
const H5O_COPY_WITHOUT_ATTR_FLAG = UInt32(0x0010)
const H5O_COPY_PRESERVE_NULL_FLAG = UInt32(0x0020)
const H5O_COPY_MERGE_COMMITTED_DTYPE_FLAG = UInt32(0x0040)
const H5O_COPY_ALL = UInt32(0x007f)
const H5O_SHMESG_NONE_FLAG = 0x0000

# Skipping MacroDefinition: H5O_SHMESG_SDSPACE_FLAG ( ( unsigned ) 1 << 0x0001 )
# Skipping MacroDefinition: H5O_SHMESG_DTYPE_FLAG ( ( unsigned ) 1 << 0x0003 )
# Skipping MacroDefinition: H5O_SHMESG_FILL_FLAG ( ( unsigned ) 1 << 0x0005 )
# Skipping MacroDefinition: H5O_SHMESG_PLINE_FLAG ( ( unsigned ) 1 << 0x000b )
# Skipping MacroDefinition: H5O_SHMESG_ATTR_FLAG ( ( unsigned ) 1 << 0x000c )

const H5O_SHMESG_ALL_FLAG = (((H5O_SHMESG_SDSPACE_FLAG | H5O_SHMESG_DTYPE_FLAG) | H5O_SHMESG_FILL_FLAG) | H5O_SHMESG_PLINE_FLAG) | H5O_SHMESG_ATTR_FLAG
const H5O_HDR_CHUNK0_SIZE = 0x03
const H5O_HDR_ATTR_CRT_ORDER_TRACKED = 0x04
const H5O_HDR_ATTR_CRT_ORDER_INDEXED = 0x08
const H5O_HDR_ATTR_STORE_PHASE_CHANGE = 0x10
const H5O_HDR_STORE_TIMES = 0x20
const H5O_HDR_ALL_FLAGS = (((H5O_HDR_CHUNK0_SIZE | H5O_HDR_ATTR_CRT_ORDER_TRACKED) | H5O_HDR_ATTR_CRT_ORDER_INDEXED) | H5O_HDR_ATTR_STORE_PHASE_CHANGE) | H5O_HDR_STORE_TIMES
const H5O_SHMESG_MAX_NINDEXES = 8
const H5O_SHMESG_MAX_LIST_SIZE = 5000

@cenum H5O_type_t::Int32 begin
    H5O_TYPE_UNKNOWN = -1
    H5O_TYPE_GROUP = 0
    H5O_TYPE_DATASET = 1
    H5O_TYPE_NAMED_DATATYPE = 2
    H5O_TYPE_NTYPES = 3
end


struct ANONYMOUS3_space
    total::hsize_t
    meta::hsize_t
    mesg::hsize_t
    free::hsize_t
end

struct ANONYMOUS4_mesg
    present::UInt64
    shared::UInt64
end

struct H5O_hdr_info_t
    version::UInt32
    nmesgs::UInt32
    nchunks::UInt32
    flags::UInt32
    space::ANONYMOUS3_space
    mesg::ANONYMOUS4_mesg
end

struct ANONYMOUS5_meta_size
    obj::H5_ih_info_t
    attr::H5_ih_info_t
end

struct H5O_info_t
    fileno::Culong
    addr::haddr_t
    type::H5O_type_t
    rc::UInt32
    atime::Ctime_t
    mtime::Ctime_t
    ctime::Ctime_t
    btime::Ctime_t
    num_attrs::hsize_t
    hdr::H5O_hdr_info_t
    meta_size::ANONYMOUS5_meta_size
end

const H5O_iterate_t = Ptr{Cvoid}

@cenum H5O_mcdt_search_ret_t::Int32 begin
    H5O_MCDT_SEARCH_ERROR = -1
    H5O_MCDT_SEARCH_CONT = 0
    H5O_MCDT_SEARCH_STOP = 1
end


const H5O_mcdt_search_cb_t = Ptr{Cvoid}

# Skipping MacroDefinition: H5PLUGIN_DLL __attribute__ ( ( visibility ( "default" ) ) )

const H5PL_FILTER_PLUGIN = 0x0001
const H5PL_ALL_PLUGIN = Float32(0x0fff)

@cenum H5PL_type_t::Int32 begin
    H5PL_TYPE_ERROR = -1
    H5PL_TYPE_FILTER = 0
    H5PL_TYPE_NONE = 1
end


# Skipping MacroDefinition: H5P_ROOT ( H5OPEN H5P_CLS_ROOT_ID_g )
# Skipping MacroDefinition: H5P_OBJECT_CREATE ( H5OPEN H5P_CLS_OBJECT_CREATE_ID_g )
# Skipping MacroDefinition: H5P_FILE_CREATE ( H5OPEN H5P_CLS_FILE_CREATE_ID_g )
# Skipping MacroDefinition: H5P_FILE_ACCESS ( H5OPEN H5P_CLS_FILE_ACCESS_ID_g )
# Skipping MacroDefinition: H5P_DATASET_CREATE ( H5OPEN H5P_CLS_DATASET_CREATE_ID_g )
# Skipping MacroDefinition: H5P_DATASET_ACCESS ( H5OPEN H5P_CLS_DATASET_ACCESS_ID_g )
# Skipping MacroDefinition: H5P_DATASET_XFER ( H5OPEN H5P_CLS_DATASET_XFER_ID_g )
# Skipping MacroDefinition: H5P_FILE_MOUNT ( H5OPEN H5P_CLS_FILE_MOUNT_ID_g )
# Skipping MacroDefinition: H5P_GROUP_CREATE ( H5OPEN H5P_CLS_GROUP_CREATE_ID_g )
# Skipping MacroDefinition: H5P_GROUP_ACCESS ( H5OPEN H5P_CLS_GROUP_ACCESS_ID_g )
# Skipping MacroDefinition: H5P_DATATYPE_CREATE ( H5OPEN H5P_CLS_DATATYPE_CREATE_ID_g )
# Skipping MacroDefinition: H5P_DATATYPE_ACCESS ( H5OPEN H5P_CLS_DATATYPE_ACCESS_ID_g )
# Skipping MacroDefinition: H5P_STRING_CREATE ( H5OPEN H5P_CLS_STRING_CREATE_ID_g )
# Skipping MacroDefinition: H5P_ATTRIBUTE_CREATE ( H5OPEN H5P_CLS_ATTRIBUTE_CREATE_ID_g )
# Skipping MacroDefinition: H5P_OBJECT_COPY ( H5OPEN H5P_CLS_OBJECT_COPY_ID_g )
# Skipping MacroDefinition: H5P_LINK_CREATE ( H5OPEN H5P_CLS_LINK_CREATE_ID_g )
# Skipping MacroDefinition: H5P_LINK_ACCESS ( H5OPEN H5P_CLS_LINK_ACCESS_ID_g )
# Skipping MacroDefinition: H5P_FILE_CREATE_DEFAULT ( H5OPEN H5P_LST_FILE_CREATE_ID_g )
# Skipping MacroDefinition: H5P_FILE_ACCESS_DEFAULT ( H5OPEN H5P_LST_FILE_ACCESS_ID_g )
# Skipping MacroDefinition: H5P_DATASET_CREATE_DEFAULT ( H5OPEN H5P_LST_DATASET_CREATE_ID_g )
# Skipping MacroDefinition: H5P_DATASET_ACCESS_DEFAULT ( H5OPEN H5P_LST_DATASET_ACCESS_ID_g )
# Skipping MacroDefinition: H5P_DATASET_XFER_DEFAULT ( H5OPEN H5P_LST_DATASET_XFER_ID_g )
# Skipping MacroDefinition: H5P_FILE_MOUNT_DEFAULT ( H5OPEN H5P_LST_FILE_MOUNT_ID_g )
# Skipping MacroDefinition: H5P_GROUP_CREATE_DEFAULT ( H5OPEN H5P_LST_GROUP_CREATE_ID_g )
# Skipping MacroDefinition: H5P_GROUP_ACCESS_DEFAULT ( H5OPEN H5P_LST_GROUP_ACCESS_ID_g )
# Skipping MacroDefinition: H5P_DATATYPE_CREATE_DEFAULT ( H5OPEN H5P_LST_DATATYPE_CREATE_ID_g )
# Skipping MacroDefinition: H5P_DATATYPE_ACCESS_DEFAULT ( H5OPEN H5P_LST_DATATYPE_ACCESS_ID_g )
# Skipping MacroDefinition: H5P_ATTRIBUTE_CREATE_DEFAULT ( H5OPEN H5P_LST_ATTRIBUTE_CREATE_ID_g )
# Skipping MacroDefinition: H5P_OBJECT_COPY_DEFAULT ( H5OPEN H5P_LST_OBJECT_COPY_ID_g )
# Skipping MacroDefinition: H5P_LINK_CREATE_DEFAULT ( H5OPEN H5P_LST_LINK_CREATE_ID_g )
# Skipping MacroDefinition: H5P_LINK_ACCESS_DEFAULT ( H5OPEN H5P_LST_LINK_ACCESS_ID_g )

const H5P_CRT_ORDER_TRACKED = 0x0001
const H5P_CRT_ORDER_INDEXED = 0x0002

# Skipping MacroDefinition: H5P_DEFAULT ( hid_t ) 0

const H5P_NO_CLASS = H5P_ROOT
const H5P_cls_create_func_t = Ptr{Cvoid}
const H5P_cls_copy_func_t = Ptr{Cvoid}
const H5P_cls_close_func_t = Ptr{Cvoid}
const H5P_prp_cb1_t = Ptr{Cvoid}
const H5P_prp_cb2_t = Ptr{Cvoid}
const H5P_prp_create_func_t = H5P_prp_cb1_t
const H5P_prp_set_func_t = H5P_prp_cb2_t
const H5P_prp_get_func_t = H5P_prp_cb2_t
const H5P_prp_delete_func_t = H5P_prp_cb2_t
const H5P_prp_copy_func_t = H5P_prp_cb1_t
const H5P_prp_compare_func_t = Ptr{Cvoid}
const H5P_prp_close_func_t = H5P_prp_cb1_t
const H5P_iterate_t = Ptr{Cvoid}

@cenum H5D_mpio_actual_chunk_opt_mode_t::UInt32 begin
    H5D_MPIO_NO_CHUNK_OPTIMIZATION = 0
    H5D_MPIO_LINK_CHUNK = 1
    H5D_MPIO_MULTI_CHUNK = 2
end

@cenum H5D_mpio_actual_io_mode_t::UInt32 begin
    H5D_MPIO_NO_COLLECTIVE = 0
    H5D_MPIO_CHUNK_INDEPENDENT = 1
    H5D_MPIO_CHUNK_COLLECTIVE = 2
    H5D_MPIO_CHUNK_MIXED = 3
    H5D_MPIO_CONTIGUOUS_COLLECTIVE = 4
end

@cenum H5D_mpio_no_collective_cause_t::UInt32 begin
    H5D_MPIO_COLLECTIVE = 0
    H5D_MPIO_SET_INDEPENDENT = 1
    H5D_MPIO_DATATYPE_CONVERSION = 2
    H5D_MPIO_DATA_TRANSFORMS = 4
    H5D_MPIO_MPI_OPT_TYPES_ENV_VAR_DISABLED = 8
    H5D_MPIO_NOT_SIMPLE_OR_SCALAR_DATASPACES = 16
    H5D_MPIO_NOT_CONTIGUOUS_OR_CHUNKED_DATASET = 32
    H5D_MPIO_FILTERS = 64
end


# Skipping MacroDefinition: H5R_OBJ_REF_BUF_SIZE sizeof ( haddr_t )
# Skipping MacroDefinition: H5R_DSET_REG_REF_BUF_SIZE ( sizeof ( haddr_t ) + 4 )

@cenum H5R_type_t::Int32 begin
    H5R_BADTYPE = -1
    H5R_OBJECT = 0
    H5R_DATASET_REGION = 1
    H5R_MAXTYPE = 2
end


const hobj_ref_t = haddr_t
const hdset_reg_ref_t = NTuple{12, Cuchar}

# Skipping MacroDefinition: H5S_ALL ( hid_t ) 0
# Skipping MacroDefinition: H5S_UNLIMITED ( ( hsize_t ) ( hssize_t ) ( - 1 ) )

const H5S_MAX_RANK = 32

@cenum H5S_class_t::Int32 begin
    H5S_NO_CLASS = -1
    H5S_SCALAR = 0
    H5S_SIMPLE = 1
    H5S_NULL = 2
end

@cenum H5S_seloper_t::Int32 begin
    H5S_SELECT_NOOP = -1
    H5S_SELECT_SET = 0
    H5S_SELECT_OR = 1
    H5S_SELECT_AND = 2
    H5S_SELECT_XOR = 3
    H5S_SELECT_NOTB = 4
    H5S_SELECT_NOTA = 5
    H5S_SELECT_APPEND = 6
    H5S_SELECT_PREPEND = 7
    H5S_SELECT_INVALID = 8
end

@cenum H5S_sel_type::Int32 begin
    H5S_SEL_ERROR = -1
    H5S_SEL_NONE = 0
    H5S_SEL_POINTS = 1
    H5S_SEL_HYPERSLABS = 2
    H5S_SEL_ALL = 3
    H5S_SEL_N = 4
end


# Skipping MacroDefinition: HOFFSET ( S , M ) ( offsetof ( S , M ) )

const H5T_NCSET = H5T_CSET_RESERVED_2

@cenum H5T_str_t::Int32 begin
    H5T_STR_ERROR = -1
    H5T_STR_NULLTERM = 0
    H5T_STR_NULLPAD = 1
    H5T_STR_SPACEPAD = 2
    H5T_STR_RESERVED_3 = 3
    H5T_STR_RESERVED_4 = 4
    H5T_STR_RESERVED_5 = 5
    H5T_STR_RESERVED_6 = 6
    H5T_STR_RESERVED_7 = 7
    H5T_STR_RESERVED_8 = 8
    H5T_STR_RESERVED_9 = 9
    H5T_STR_RESERVED_10 = 10
    H5T_STR_RESERVED_11 = 11
    H5T_STR_RESERVED_12 = 12
    H5T_STR_RESERVED_13 = 13
    H5T_STR_RESERVED_14 = 14
    H5T_STR_RESERVED_15 = 15
end


const H5T_NSTR = H5T_STR_RESERVED_3

# Skipping MacroDefinition: H5T_VARIABLE ( ( size_t ) ( - 1 ) )

const H5T_OPAQUE_TAG_MAX = 256

# Skipping MacroDefinition: H5T_IEEE_F32BE ( H5OPEN H5T_IEEE_F32BE_g )
# Skipping MacroDefinition: H5T_IEEE_F32LE ( H5OPEN H5T_IEEE_F32LE_g )
# Skipping MacroDefinition: H5T_IEEE_F64BE ( H5OPEN H5T_IEEE_F64BE_g )
# Skipping MacroDefinition: H5T_IEEE_F64LE ( H5OPEN H5T_IEEE_F64LE_g )
# Skipping MacroDefinition: H5T_STD_I8BE ( H5OPEN H5T_STD_I8BE_g )
# Skipping MacroDefinition: H5T_STD_I8LE ( H5OPEN H5T_STD_I8LE_g )
# Skipping MacroDefinition: H5T_STD_I16BE ( H5OPEN H5T_STD_I16BE_g )
# Skipping MacroDefinition: H5T_STD_I16LE ( H5OPEN H5T_STD_I16LE_g )
# Skipping MacroDefinition: H5T_STD_I32BE ( H5OPEN H5T_STD_I32BE_g )
# Skipping MacroDefinition: H5T_STD_I32LE ( H5OPEN H5T_STD_I32LE_g )
# Skipping MacroDefinition: H5T_STD_I64BE ( H5OPEN H5T_STD_I64BE_g )
# Skipping MacroDefinition: H5T_STD_I64LE ( H5OPEN H5T_STD_I64LE_g )
# Skipping MacroDefinition: H5T_STD_U8BE ( H5OPEN H5T_STD_U8BE_g )
# Skipping MacroDefinition: H5T_STD_U8LE ( H5OPEN H5T_STD_U8LE_g )
# Skipping MacroDefinition: H5T_STD_U16BE ( H5OPEN H5T_STD_U16BE_g )
# Skipping MacroDefinition: H5T_STD_U16LE ( H5OPEN H5T_STD_U16LE_g )
# Skipping MacroDefinition: H5T_STD_U32BE ( H5OPEN H5T_STD_U32BE_g )
# Skipping MacroDefinition: H5T_STD_U32LE ( H5OPEN H5T_STD_U32LE_g )
# Skipping MacroDefinition: H5T_STD_U64BE ( H5OPEN H5T_STD_U64BE_g )
# Skipping MacroDefinition: H5T_STD_U64LE ( H5OPEN H5T_STD_U64LE_g )
# Skipping MacroDefinition: H5T_STD_B8BE ( H5OPEN H5T_STD_B8BE_g )
# Skipping MacroDefinition: H5T_STD_B8LE ( H5OPEN H5T_STD_B8LE_g )
# Skipping MacroDefinition: H5T_STD_B16BE ( H5OPEN H5T_STD_B16BE_g )
# Skipping MacroDefinition: H5T_STD_B16LE ( H5OPEN H5T_STD_B16LE_g )
# Skipping MacroDefinition: H5T_STD_B32BE ( H5OPEN H5T_STD_B32BE_g )
# Skipping MacroDefinition: H5T_STD_B32LE ( H5OPEN H5T_STD_B32LE_g )
# Skipping MacroDefinition: H5T_STD_B64BE ( H5OPEN H5T_STD_B64BE_g )
# Skipping MacroDefinition: H5T_STD_B64LE ( H5OPEN H5T_STD_B64LE_g )
# Skipping MacroDefinition: H5T_STD_REF_OBJ ( H5OPEN H5T_STD_REF_OBJ_g )
# Skipping MacroDefinition: H5T_STD_REF_DSETREG ( H5OPEN H5T_STD_REF_DSETREG_g )
# Skipping MacroDefinition: H5T_UNIX_D32BE ( H5OPEN H5T_UNIX_D32BE_g )
# Skipping MacroDefinition: H5T_UNIX_D32LE ( H5OPEN H5T_UNIX_D32LE_g )
# Skipping MacroDefinition: H5T_UNIX_D64BE ( H5OPEN H5T_UNIX_D64BE_g )
# Skipping MacroDefinition: H5T_UNIX_D64LE ( H5OPEN H5T_UNIX_D64LE_g )
# Skipping MacroDefinition: H5T_C_S1 ( H5OPEN H5T_C_S1_g )
# Skipping MacroDefinition: H5T_FORTRAN_S1 ( H5OPEN H5T_FORTRAN_S1_g )

const H5T_INTEL_I8 = H5T_STD_I8LE
const H5T_INTEL_I16 = H5T_STD_I16LE
const H5T_INTEL_I32 = H5T_STD_I32LE
const H5T_INTEL_I64 = H5T_STD_I64LE
const H5T_INTEL_U8 = H5T_STD_U8LE
const H5T_INTEL_U16 = H5T_STD_U16LE
const H5T_INTEL_U32 = H5T_STD_U32LE
const H5T_INTEL_U64 = H5T_STD_U64LE
const H5T_INTEL_B8 = H5T_STD_B8LE
const H5T_INTEL_B16 = H5T_STD_B16LE
const H5T_INTEL_B32 = H5T_STD_B32LE
const H5T_INTEL_B64 = H5T_STD_B64LE
const H5T_INTEL_F32 = H5T_IEEE_F32LE
const H5T_INTEL_F64 = H5T_IEEE_F64LE
const H5T_ALPHA_I8 = H5T_STD_I8LE
const H5T_ALPHA_I16 = H5T_STD_I16LE
const H5T_ALPHA_I32 = H5T_STD_I32LE
const H5T_ALPHA_I64 = H5T_STD_I64LE
const H5T_ALPHA_U8 = H5T_STD_U8LE
const H5T_ALPHA_U16 = H5T_STD_U16LE
const H5T_ALPHA_U32 = H5T_STD_U32LE
const H5T_ALPHA_U64 = H5T_STD_U64LE
const H5T_ALPHA_B8 = H5T_STD_B8LE
const H5T_ALPHA_B16 = H5T_STD_B16LE
const H5T_ALPHA_B32 = H5T_STD_B32LE
const H5T_ALPHA_B64 = H5T_STD_B64LE
const H5T_ALPHA_F32 = H5T_IEEE_F32LE
const H5T_ALPHA_F64 = H5T_IEEE_F64LE
const H5T_MIPS_I8 = H5T_STD_I8BE
const H5T_MIPS_I16 = H5T_STD_I16BE
const H5T_MIPS_I32 = H5T_STD_I32BE
const H5T_MIPS_I64 = H5T_STD_I64BE
const H5T_MIPS_U8 = H5T_STD_U8BE
const H5T_MIPS_U16 = H5T_STD_U16BE
const H5T_MIPS_U32 = H5T_STD_U32BE
const H5T_MIPS_U64 = H5T_STD_U64BE
const H5T_MIPS_B8 = H5T_STD_B8BE
const H5T_MIPS_B16 = H5T_STD_B16BE
const H5T_MIPS_B32 = H5T_STD_B32BE
const H5T_MIPS_B64 = H5T_STD_B64BE
const H5T_MIPS_F32 = H5T_IEEE_F32BE
const H5T_MIPS_F64 = H5T_IEEE_F64BE

# Skipping MacroDefinition: H5T_VAX_F32 ( H5OPEN H5T_VAX_F32_g )
# Skipping MacroDefinition: H5T_VAX_F64 ( H5OPEN H5T_VAX_F64_g )
# Skipping MacroDefinition: H5T_NATIVE_CHAR ( CHAR_MIN ? H5T_NATIVE_SCHAR : H5T_NATIVE_UCHAR )
# Skipping MacroDefinition: H5T_NATIVE_SCHAR ( H5OPEN H5T_NATIVE_SCHAR_g )
# Skipping MacroDefinition: H5T_NATIVE_UCHAR ( H5OPEN H5T_NATIVE_UCHAR_g )
# Skipping MacroDefinition: H5T_NATIVE_SHORT ( H5OPEN H5T_NATIVE_SHORT_g )
# Skipping MacroDefinition: H5T_NATIVE_USHORT ( H5OPEN H5T_NATIVE_USHORT_g )
# Skipping MacroDefinition: H5T_NATIVE_INT ( H5OPEN H5T_NATIVE_INT_g )
# Skipping MacroDefinition: H5T_NATIVE_UINT ( H5OPEN H5T_NATIVE_UINT_g )
# Skipping MacroDefinition: H5T_NATIVE_LONG ( H5OPEN H5T_NATIVE_LONG_g )
# Skipping MacroDefinition: H5T_NATIVE_ULONG ( H5OPEN H5T_NATIVE_ULONG_g )
# Skipping MacroDefinition: H5T_NATIVE_LLONG ( H5OPEN H5T_NATIVE_LLONG_g )
# Skipping MacroDefinition: H5T_NATIVE_ULLONG ( H5OPEN H5T_NATIVE_ULLONG_g )
# Skipping MacroDefinition: H5T_NATIVE_FLOAT ( H5OPEN H5T_NATIVE_FLOAT_g )
# Skipping MacroDefinition: H5T_NATIVE_DOUBLE ( H5OPEN H5T_NATIVE_DOUBLE_g )
# Skipping MacroDefinition: H5T_NATIVE_LDOUBLE ( H5OPEN H5T_NATIVE_LDOUBLE_g )
# Skipping MacroDefinition: H5T_NATIVE_B8 ( H5OPEN H5T_NATIVE_B8_g )
# Skipping MacroDefinition: H5T_NATIVE_B16 ( H5OPEN H5T_NATIVE_B16_g )
# Skipping MacroDefinition: H5T_NATIVE_B32 ( H5OPEN H5T_NATIVE_B32_g )
# Skipping MacroDefinition: H5T_NATIVE_B64 ( H5OPEN H5T_NATIVE_B64_g )
# Skipping MacroDefinition: H5T_NATIVE_OPAQUE ( H5OPEN H5T_NATIVE_OPAQUE_g )
# Skipping MacroDefinition: H5T_NATIVE_HADDR ( H5OPEN H5T_NATIVE_HADDR_g )
# Skipping MacroDefinition: H5T_NATIVE_HSIZE ( H5OPEN H5T_NATIVE_HSIZE_g )
# Skipping MacroDefinition: H5T_NATIVE_HSSIZE ( H5OPEN H5T_NATIVE_HSSIZE_g )
# Skipping MacroDefinition: H5T_NATIVE_HERR ( H5OPEN H5T_NATIVE_HERR_g )
# Skipping MacroDefinition: H5T_NATIVE_HBOOL ( H5OPEN H5T_NATIVE_HBOOL_g )
# Skipping MacroDefinition: H5T_NATIVE_INT8 ( H5OPEN H5T_NATIVE_INT8_g )
# Skipping MacroDefinition: H5T_NATIVE_UINT8 ( H5OPEN H5T_NATIVE_UINT8_g )
# Skipping MacroDefinition: H5T_NATIVE_INT_LEAST8 ( H5OPEN H5T_NATIVE_INT_LEAST8_g )
# Skipping MacroDefinition: H5T_NATIVE_UINT_LEAST8 ( H5OPEN H5T_NATIVE_UINT_LEAST8_g )
# Skipping MacroDefinition: H5T_NATIVE_INT_FAST8 ( H5OPEN H5T_NATIVE_INT_FAST8_g )
# Skipping MacroDefinition: H5T_NATIVE_UINT_FAST8 ( H5OPEN H5T_NATIVE_UINT_FAST8_g )
# Skipping MacroDefinition: H5T_NATIVE_INT16 ( H5OPEN H5T_NATIVE_INT16_g )
# Skipping MacroDefinition: H5T_NATIVE_UINT16 ( H5OPEN H5T_NATIVE_UINT16_g )
# Skipping MacroDefinition: H5T_NATIVE_INT_LEAST16 ( H5OPEN H5T_NATIVE_INT_LEAST16_g )
# Skipping MacroDefinition: H5T_NATIVE_UINT_LEAST16 ( H5OPEN H5T_NATIVE_UINT_LEAST16_g )
# Skipping MacroDefinition: H5T_NATIVE_INT_FAST16 ( H5OPEN H5T_NATIVE_INT_FAST16_g )
# Skipping MacroDefinition: H5T_NATIVE_UINT_FAST16 ( H5OPEN H5T_NATIVE_UINT_FAST16_g )
# Skipping MacroDefinition: H5T_NATIVE_INT32 ( H5OPEN H5T_NATIVE_INT32_g )
# Skipping MacroDefinition: H5T_NATIVE_UINT32 ( H5OPEN H5T_NATIVE_UINT32_g )
# Skipping MacroDefinition: H5T_NATIVE_INT_LEAST32 ( H5OPEN H5T_NATIVE_INT_LEAST32_g )
# Skipping MacroDefinition: H5T_NATIVE_UINT_LEAST32 ( H5OPEN H5T_NATIVE_UINT_LEAST32_g )
# Skipping MacroDefinition: H5T_NATIVE_INT_FAST32 ( H5OPEN H5T_NATIVE_INT_FAST32_g )
# Skipping MacroDefinition: H5T_NATIVE_UINT_FAST32 ( H5OPEN H5T_NATIVE_UINT_FAST32_g )
# Skipping MacroDefinition: H5T_NATIVE_INT64 ( H5OPEN H5T_NATIVE_INT64_g )
# Skipping MacroDefinition: H5T_NATIVE_UINT64 ( H5OPEN H5T_NATIVE_UINT64_g )
# Skipping MacroDefinition: H5T_NATIVE_INT_LEAST64 ( H5OPEN H5T_NATIVE_INT_LEAST64_g )
# Skipping MacroDefinition: H5T_NATIVE_UINT_LEAST64 ( H5OPEN H5T_NATIVE_UINT_LEAST64_g )
# Skipping MacroDefinition: H5T_NATIVE_INT_FAST64 ( H5OPEN H5T_NATIVE_INT_FAST64_g )
# Skipping MacroDefinition: H5T_NATIVE_UINT_FAST64 ( H5OPEN H5T_NATIVE_UINT_FAST64_g )

@cenum H5T_class_t::Int32 begin
    H5T_NO_CLASS = -1
    H5T_INTEGER = 0
    H5T_FLOAT = 1
    H5T_TIME = 2
    H5T_STRING = 3
    H5T_BITFIELD = 4
    H5T_OPAQUE = 5
    H5T_COMPOUND = 6
    H5T_REFERENCE = 7
    H5T_ENUM = 8
    H5T_VLEN = 9
    H5T_ARRAY = 10
    H5T_NCLASSES = 11
end

@cenum H5T_order_t::Int32 begin
    H5T_ORDER_ERROR = -1
    H5T_ORDER_LE = 0
    H5T_ORDER_BE = 1
    H5T_ORDER_VAX = 2
    H5T_ORDER_MIXED = 3
    H5T_ORDER_NONE = 4
end

@cenum H5T_sign_t::Int32 begin
    H5T_SGN_ERROR = -1
    H5T_SGN_NONE = 0
    H5T_SGN_2 = 1
    H5T_NSGN = 2
end

@cenum H5T_norm_t::Int32 begin
    H5T_NORM_ERROR = -1
    H5T_NORM_IMPLIED = 0
    H5T_NORM_MSBSET = 1
    H5T_NORM_NONE = 2
end

@cenum H5T_pad_t::Int32 begin
    H5T_PAD_ERROR = -1
    H5T_PAD_ZERO = 0
    H5T_PAD_ONE = 1
    H5T_PAD_BACKGROUND = 2
    H5T_NPAD = 3
end

@cenum H5T_cmd_t::UInt32 begin
    H5T_CONV_INIT = 0
    H5T_CONV_CONV = 1
    H5T_CONV_FREE = 2
end

@cenum H5T_bkg_t::UInt32 begin
    H5T_BKG_NO = 0
    H5T_BKG_TEMP = 1
    H5T_BKG_YES = 2
end


struct H5T_cdata_t
    command::H5T_cmd_t
    need_bkg::H5T_bkg_t
    recalc::hbool_t
    priv::Ptr{Cvoid}
end

@cenum H5T_pers_t::Int32 begin
    H5T_PERS_DONTCARE = -1
    H5T_PERS_HARD = 0
    H5T_PERS_SOFT = 1
end

@cenum H5T_direction_t::UInt32 begin
    H5T_DIR_DEFAULT = 0
    H5T_DIR_ASCEND = 1
    H5T_DIR_DESCEND = 2
end

@cenum H5T_conv_except_t::UInt32 begin
    H5T_CONV_EXCEPT_RANGE_HI = 0
    H5T_CONV_EXCEPT_RANGE_LOW = 1
    H5T_CONV_EXCEPT_PRECISION = 2
    H5T_CONV_EXCEPT_TRUNCATE = 3
    H5T_CONV_EXCEPT_PINF = 4
    H5T_CONV_EXCEPT_NINF = 5
    H5T_CONV_EXCEPT_NAN = 6
end

@cenum H5T_conv_ret_t::Int32 begin
    H5T_CONV_ABORT = -1
    H5T_CONV_UNHANDLED = 0
    H5T_CONV_HANDLED = 1
end


struct hvl_t
    len::Csize_t
    p::Ptr{Cvoid}
end

const H5T_conv_t = Ptr{Cvoid}
const H5T_conv_except_func_t = Ptr{Cvoid}
const H5Z_FILTER_ERROR = -1
const H5Z_FILTER_NONE = 0
const H5Z_FILTER_DEFLATE = 1
const H5Z_FILTER_SHUFFLE = 2
const H5Z_FILTER_FLETCHER32 = 3
const H5Z_FILTER_SZIP = 4
const H5Z_FILTER_NBIT = 5
const H5Z_FILTER_SCALEOFFSET = 6
const H5Z_FILTER_RESERVED = 256
const H5Z_FILTER_MAX = 65535
const H5Z_FILTER_ALL = 0
const H5Z_MAX_NFILTERS = 32
const H5Z_FLAG_DEFMASK = Float32(0x000f)
const H5Z_FLAG_MANDATORY = 0x0000
const H5Z_FLAG_OPTIONAL = 0x0001
const H5Z_FLAG_INVMASK = 0xff00
const H5Z_FLAG_REVERSE = 0x0100
const H5Z_FLAG_SKIP_EDC = 0x0200
const H5_SZIP_ALLOW_K13_OPTION_MASK = 1
const H5_SZIP_CHIP_OPTION_MASK = 2
const H5_SZIP_EC_OPTION_MASK = 4
const H5_SZIP_NN_OPTION_MASK = 32
const H5_SZIP_MAX_PIXELS_PER_BLOCK = 32
const H5Z_SHUFFLE_USER_NPARMS = 0
const H5Z_SHUFFLE_TOTAL_NPARMS = 1
const H5Z_SZIP_USER_NPARMS = 2
const H5Z_SZIP_TOTAL_NPARMS = 4
const H5Z_SZIP_PARM_MASK = 0
const H5Z_SZIP_PARM_PPB = 1
const H5Z_SZIP_PARM_BPP = 2
const H5Z_SZIP_PARM_PPS = 3
const H5Z_NBIT_USER_NPARMS = 0
const H5Z_SCALEOFFSET_USER_NPARMS = 2
const H5Z_SO_INT_MINBITS_DEFAULT = 0
const H5Z_CLASS_T_VERS = 1
const H5Z_FILTER_CONFIG_ENCODE_ENABLED = 0x0001
const H5Z_FILTER_CONFIG_DECODE_ENABLED = 0x0002
const H5Z_filter_t = Cint

@cenum H5Z_SO_scale_type_t::UInt32 begin
    H5Z_SO_FLOAT_DSCALE = 0
    H5Z_SO_FLOAT_ESCALE = 1
    H5Z_SO_INT = 2
end

@cenum H5Z_EDC_t::Int32 begin
    H5Z_ERROR_EDC = -1
    H5Z_DISABLE_EDC = 0
    H5Z_ENABLE_EDC = 1
    H5Z_NO_EDC = 2
end

@cenum H5Z_cb_return_t::Int32 begin
    H5Z_CB_ERROR = -1
    H5Z_CB_FAIL = 0
    H5Z_CB_CONT = 1
    H5Z_CB_NO = 2
end


const H5Z_filter_func_t = Ptr{Cvoid}

struct H5Z_cb_t
    func::H5Z_filter_func_t
    op_data::Ptr{Cvoid}
end

const H5Z_can_apply_func_t = Ptr{Cvoid}
const H5Z_set_local_func_t = Ptr{Cvoid}
const H5Z_func_t = Ptr{Cvoid}

struct H5Z_class2_t
    version::Cint
    id::H5Z_filter_t
    encoder_present::UInt32
    decoder_present::UInt32
    name::Cstring
    can_apply::H5Z_can_apply_func_t
    set_local::H5Z_set_local_func_t
    filter::H5Z_func_t
end

struct H5Z_class1_t
    id::H5Z_filter_t
    name::Cstring
    can_apply::H5Z_can_apply_func_t
    set_local::H5Z_set_local_func_t
    filter::H5Z_func_t
end

# Skipping MacroDefinition: H5_ATTR_FORMAT ( X , Y , Z )
# Skipping MacroDefinition: ASSIGN_unsigned_TO_int ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_UNSIGNED_TO_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_unsigned_TO_uint8_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_unsigned_TO_uint16_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_unsigned_TO_uint32_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_unsigned_TO_uint64_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_unsigned_TO_ptrdiff_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_UNSIGNED_TO_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_unsigned_TO_size_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_unsigned_TO_ssize_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_UNSIGNED_TO_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_unsigned_TO_haddr_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_unsigned_TO_hsize_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_unsigned_TO_hssize_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_UNSIGNED_TO_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_unsigned_TO_h5_stat_size_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_int_TO_unsigned ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SIGNED_TO_UNSIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_int_TO_uint8_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SIGNED_TO_UNSIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_int_TO_uint16_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SIGNED_TO_UNSIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_int_TO_uint32_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SIGNED_TO_UNSIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_int_TO_uint64_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SIGNED_TO_UNSIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_int_TO_ptrdiff_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_int_TO_size_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SIGNED_TO_UNSIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_int_TO_ssize_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_int_TO_haddr_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SIGNED_TO_UNSIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_int_TO_hsize_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SIGNED_TO_UNSIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_int_TO_hssize_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_int_TO_h5_stat_size_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SIGNED_TO_UNSIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_uint8_t_TO_unsigned ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_uint8_t_TO_int ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_UNSIGNED_TO_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_uint8_t_TO_uint16_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_uint8_t_TO_uint32_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_uint8_t_TO_uint64_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_uint8_t_TO_ptrdiff_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_UNSIGNED_TO_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_uint8_t_TO_size_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_uint8_t_TO_ssize_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_UNSIGNED_TO_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_uint8_t_TO_haddr_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_uint8_t_TO_hsize_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_uint8_t_TO_hssize_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_UNSIGNED_TO_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_uint8_t_TO_h5_stat_size_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_uint16_t_TO_unsigned ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_uint16_t_TO_int ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_UNSIGNED_TO_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_uint16_t_TO_uint8_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_uint16_t_TO_uint32_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_uint16_t_TO_uint64_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_uint16_t_TO_ptrdiff_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_UNSIGNED_TO_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_uint16_t_TO_size_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_uint16_t_TO_ssize_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_UNSIGNED_TO_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_uint16_t_TO_haddr_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_uint16_t_TO_hsize_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_uint16_t_TO_hssize_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_UNSIGNED_TO_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_uint16_t_TO_h5_stat_size_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_uint32_t_TO_unsigned ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_uint32_t_TO_int ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_UNSIGNED_TO_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_uint32_t_TO_uint8_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_uint32_t_TO_uint16_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_uint32_t_TO_uint64_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_uint32_t_TO_ptrdiff_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_UNSIGNED_TO_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_uint32_t_TO_size_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_uint32_t_TO_ssize_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_UNSIGNED_TO_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_uint32_t_TO_haddr_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_uint32_t_TO_hsize_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_uint32_t_TO_hssize_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_UNSIGNED_TO_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_uint32_t_TO_h5_stat_size_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_uint64_t_TO_unsigned ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_uint64_t_TO_int ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_UNSIGNED_TO_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_uint64_t_TO_uint8_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_uint64_t_TO_uint16_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_uint64_t_TO_uint32_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_uint64_t_TO_ptrdiff_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_UNSIGNED_TO_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_uint64_t_TO_size_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_uint64_t_TO_ssize_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_UNSIGNED_TO_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_uint64_t_TO_haddr_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_uint64_t_TO_hsize_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_uint64_t_TO_hssize_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_UNSIGNED_TO_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_uint64_t_TO_h5_stat_size_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_ptrdiff_t_TO_unsigned ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SIGNED_TO_UNSIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_ptrdiff_t_TO_int ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_ptrdiff_t_TO_uint8_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SIGNED_TO_UNSIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_ptrdiff_t_TO_uint16_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SIGNED_TO_UNSIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_ptrdiff_t_TO_uint32_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SIGNED_TO_UNSIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_ptrdiff_t_TO_uint64_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SIGNED_TO_UNSIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_ptrdiff_t_TO_size_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SIGNED_TO_UNSIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_ptrdiff_t_TO_ssize_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_ptrdiff_t_TO_haddr_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SIGNED_TO_UNSIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_ptrdiff_t_TO_hsize_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SIGNED_TO_UNSIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_ptrdiff_t_TO_hssize_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_ptrdiff_t_TO_h5_stat_size_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SIGNED_TO_UNSIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_size_t_TO_unsigned ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_size_t_TO_int ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_UNSIGNED_TO_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_size_t_TO_uint8_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_size_t_TO_uint16_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_size_t_TO_uint32_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_size_t_TO_uint64_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_size_t_TO_ptrdiff_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_UNSIGNED_TO_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_size_t_TO_ssize_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_UNSIGNED_TO_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_size_t_TO_haddr_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_size_t_TO_hsize_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_size_t_TO_hssize_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_UNSIGNED_TO_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_size_t_TO_h5_stat_size_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_ssize_t_TO_unsigned ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SIGNED_TO_UNSIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_ssize_t_TO_int ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_ssize_t_TO_uint8_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SIGNED_TO_UNSIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_ssize_t_TO_uint16_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SIGNED_TO_UNSIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_ssize_t_TO_uint32_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SIGNED_TO_UNSIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_ssize_t_TO_uint64_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SIGNED_TO_UNSIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_ssize_t_TO_ptrdiff_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_ssize_t_TO_size_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SIGNED_TO_UNSIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_ssize_t_TO_haddr_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SIGNED_TO_UNSIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_ssize_t_TO_hsize_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SIGNED_TO_UNSIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_ssize_t_TO_hssize_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_ssize_t_TO_h5_stat_size_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SIGNED_TO_UNSIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_haddr_t_TO_unsigned ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_haddr_t_TO_int ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_UNSIGNED_TO_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_haddr_t_TO_uint8_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_haddr_t_TO_uint16_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_haddr_t_TO_uint32_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_haddr_t_TO_uint64_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_haddr_t_TO_ptrdiff_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_UNSIGNED_TO_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_haddr_t_TO_size_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_haddr_t_TO_ssize_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_UNSIGNED_TO_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_haddr_t_TO_hsize_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_haddr_t_TO_hssize_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_UNSIGNED_TO_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_haddr_t_TO_h5_stat_size_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_hsize_t_TO_unsigned ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_hsize_t_TO_int ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_UNSIGNED_TO_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_hsize_t_TO_uint8_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_hsize_t_TO_uint16_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_hsize_t_TO_uint32_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_hsize_t_TO_uint64_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_hsize_t_TO_ptrdiff_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_UNSIGNED_TO_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_hsize_t_TO_size_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_hsize_t_TO_ssize_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_UNSIGNED_TO_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_hsize_t_TO_haddr_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_hsize_t_TO_hssize_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_UNSIGNED_TO_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_hsize_t_TO_h5_stat_size_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_hssize_t_TO_unsigned ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SIGNED_TO_UNSIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_hssize_t_TO_int ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_hssize_t_TO_uint8_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SIGNED_TO_UNSIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_hssize_t_TO_uint16_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SIGNED_TO_UNSIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_hssize_t_TO_uint32_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SIGNED_TO_UNSIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_hssize_t_TO_uint64_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SIGNED_TO_UNSIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_hssize_t_TO_ptrdiff_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_hssize_t_TO_size_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SIGNED_TO_UNSIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_hssize_t_TO_ssize_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_hssize_t_TO_haddr_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SIGNED_TO_UNSIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_hssize_t_TO_hsize_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SIGNED_TO_UNSIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_hssize_t_TO_h5_stat_size_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SIGNED_TO_UNSIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_h5_stat_size_t_TO_unsigned ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_h5_stat_size_t_TO_int ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_UNSIGNED_TO_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_h5_stat_size_t_TO_uint8_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_h5_stat_size_t_TO_uint16_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_h5_stat_size_t_TO_uint32_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_h5_stat_size_t_TO_uint64_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_h5_stat_size_t_TO_ptrdiff_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_UNSIGNED_TO_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_h5_stat_size_t_TO_size_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_h5_stat_size_t_TO_ssize_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_UNSIGNED_TO_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_h5_stat_size_t_TO_haddr_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_h5_stat_size_t_TO_hsize_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_SAME_SIGNED ( dst , dsttype , src , srctype )
# Skipping MacroDefinition: ASSIGN_h5_stat_size_t_TO_hssize_t ( dst , dsttype , src , srctype ) ASSIGN_TO_SAME_SIZE_UNSIGNED_TO_SIGNED ( dst , dsttype , src , srctype )

const H5_CLEAR_MEMORY = 1
const H5_DEFAULT_PLUGINDIR = "/usr/local/hdf5/lib/plugin"
const H5_DEV_T_IS_SCALAR = 1
const H5_HAVE_ALARM = 1
const H5_HAVE_ASPRINTF = 1
const H5_HAVE_ATTRIBUTE = 1
const H5_HAVE_C99_DESIGNATED_INITIALIZER = 1
const H5_HAVE_C99_FUNC = 1
const H5_HAVE_CLOCK_GETTIME = 1
const H5_HAVE_DIFFTIME = 1
const H5_HAVE_DIRENT_H = 1
const H5_HAVE_DLFCN_H = 1
const H5_HAVE_EMBEDDED_LIBINFO = 1
const H5_HAVE_FEATURES_H = 1
const H5_HAVE_FILTER_DEFLATE = 1
const H5_HAVE_FORK = 1
const H5_HAVE_FREXPF = 1
const H5_HAVE_FREXPL = 1
const H5_HAVE_FUNCTION = 1
const H5_HAVE_GETHOSTNAME = 1
const H5_HAVE_GETPWUID = 1
const H5_HAVE_GETRUSAGE = 1
const H5_HAVE_GETTIMEOFDAY = 1
const H5_HAVE_INLINE = 1
const H5_HAVE_INTTYPES_H = 1
const H5_HAVE_IOCTL = 1
const H5_HAVE_LIBDL = 1
const H5_HAVE_LIBM = 1
const H5_HAVE_LIBZ = 1
const H5_HAVE_LONGJMP = 1
const H5_HAVE_LSTAT = 1
const H5_HAVE_MEMORY_H = 1
const H5_HAVE_RANDOM = 1
const H5_HAVE_RAND_R = 1
const H5_HAVE_SETJMP = 1
const H5_HAVE_SETJMP_H = 1
const H5_HAVE_SIGLONGJMP = 1
const H5_HAVE_SIGNAL = 1
const H5_HAVE_SIGPROCMASK = 1
const H5_HAVE_SIGSETJMP = 1
const H5_HAVE_SNPRINTF = 1
const H5_HAVE_SRANDOM = 1
const H5_HAVE_STAT_ST_BLOCKS = 1
const H5_HAVE_STDDEF_H = 1
const H5_HAVE_STDINT_H = 1
const H5_HAVE_STDLIB_H = 1
const H5_HAVE_STRDUP = 1
const H5_HAVE_STRINGS_H = 1
const H5_HAVE_STRING_H = 1
const H5_HAVE_STRTOLL = 1
const H5_HAVE_STRTOULL = 1
const H5_HAVE_SYMLINK = 1
const H5_HAVE_SYSTEM = 1
const H5_HAVE_SYS_IOCTL_H = 1
const H5_HAVE_SYS_RESOURCE_H = 1
const H5_HAVE_SYS_SOCKET_H = 1
const H5_HAVE_SYS_STAT_H = 1
const H5_HAVE_SYS_TIMEB_H = 1
const H5_HAVE_SYS_TIME_H = 1
const H5_HAVE_SYS_TYPES_H = 1
const H5_HAVE_TIMEZONE = 1
const H5_HAVE_TIOCGETD = 1
const H5_HAVE_TIOCGWINSZ = 1
const H5_HAVE_TMPFILE = 1
const H5_HAVE_TM_GMTOFF = 1
const H5_HAVE_UNISTD_H = 1
const H5_HAVE_VASPRINTF = 1
const H5_HAVE_VSNPRINTF = 1
const H5_HAVE_WAITPID = 1
const H5_HAVE_ZLIB_H = 1
const H5_HAVE___INLINE = 1
const H5_HAVE___INLINE__ = 1
const H5_INCLUDE_HL = 1
const H5_LDOUBLE_TO_LLONG_ACCURATE = 1
const H5_LLONG_TO_LDOUBLE_CORRECT = 1
const H5_LT_OBJDIR = ".libs/"
const H5_NO_ALIGNMENT_RESTRICTIONS = 1
const H5_PACKAGE = "hdf5"
const H5_PACKAGE_BUGREPORT = "help@hdfgroup.org"
const H5_PACKAGE_NAME = "HDF5"
const H5_PACKAGE_STRING = "HDF5 1.8.19"
const H5_PACKAGE_TARNAME = "hdf5"
const H5_PACKAGE_URL = ""
const H5_PACKAGE_VERSION = "1.8.19"
const H5_PRINTF_LL_WIDTH = "l"
const H5_SIZEOF_CHAR = 1
const H5_SIZEOF_DOUBLE = 8
const H5_SIZEOF_FLOAT = 4
const H5_SIZEOF_INT16_T = 2
const H5_SIZEOF_INT32_T = 4
const H5_SIZEOF_INT64_T = 8
const H5_SIZEOF_INT8_T = 1
const H5_SIZEOF_INT_FAST16_T = 4
const H5_SIZEOF_INT_FAST32_T = 4
const H5_SIZEOF_INT_FAST64_T = 8
const H5_SIZEOF_INT_FAST8_T = 1
const H5_SIZEOF_INT_LEAST16_T = 2
const H5_SIZEOF_INT_LEAST32_T = 4
const H5_SIZEOF_INT_LEAST64_T = 8
const H5_SIZEOF_INT_LEAST8_T = 1
const H5_SIZEOF_LONG = 8
const H5_SIZEOF_LONG_DOUBLE = 16
const H5_SIZEOF_LONG_LONG = 8
const H5_SIZEOF_OFF_T = 8
const H5_SIZEOF_PTRDIFF_T = 8
const H5_SIZEOF_SHORT = 2
const H5_SIZEOF_SIZE_T = 8
const H5_SIZEOF_SSIZE_T = 8
const H5_SIZEOF_UINT16_T = 2
const H5_SIZEOF_UINT32_T = 4
const H5_SIZEOF_UINT64_T = 8
const H5_SIZEOF_UINT8_T = 1
const H5_SIZEOF_UINT_FAST16_T = 4
const H5_SIZEOF_UINT_FAST32_T = 4
const H5_SIZEOF_UINT_FAST64_T = 8
const H5_SIZEOF_UINT_FAST8_T = 1
const H5_SIZEOF_UINT_LEAST16_T = 2
const H5_SIZEOF_UINT_LEAST32_T = 4
const H5_SIZEOF_UINT_LEAST64_T = 8
const H5_SIZEOF_UINT_LEAST8_T = 1
const H5_SIZEOF_UNSIGNED = 4
const H5_SIZEOF___INT64 = 0
const H5_STDC_HEADERS = 1
const H5_SYSTEM_SCOPE_THREADS = 1
const H5_TIME_WITH_SYS_TIME = 1
const H5_VERSION = "1.8.19"
const H5_WANT_DATA_ACCURACY = 1
const H5_WANT_DCONV_EXCEPTION = 1
const H5_GCC_DIAG_OFF = x
const H5_GCC_DIAG_ON = x
const H5_VERS_MAJOR = 1
const H5_VERS_MINOR = 8
const H5_VERS_RELEASE = 19
const H5_VERS_SUBRELEASE = ""
const H5_VERS_INFO = "HDF5 library version: 1.8.19"

# Skipping MacroDefinition: H5check ( ) H5check_version ( H5_VERS_MAJOR , H5_VERS_MINOR , H5_VERS_RELEASE )
# Skipping MacroDefinition: H5_VERSION_GE ( Maj , Min , Rel ) ( ( ( H5_VERS_MAJOR == Maj ) && ( H5_VERS_MINOR == Min ) && ( H5_VERS_RELEASE >= Rel ) ) || ( ( H5_VERS_MAJOR == Maj ) && ( H5_VERS_MINOR > Min ) ) || ( H5_VERS_MAJOR > Maj ) )
# Skipping MacroDefinition: H5_VERSION_LE ( Maj , Min , Rel ) ( ( ( H5_VERS_MAJOR == Maj ) && ( H5_VERS_MINOR == Min ) && ( H5_VERS_RELEASE <= Rel ) ) || ( ( H5_VERS_MAJOR == Maj ) && ( H5_VERS_MINOR < Min ) ) || ( H5_VERS_MAJOR < Maj ) )

const H5_SIZEOF_HSIZE_T = H5_SIZEOF_LONG_LONG
const H5_SIZEOF_HSSIZE_T = H5_SIZEOF_LONG_LONG

# Skipping MacroDefinition: HADDR_UNDEF ( ( haddr_t ) ( int64_t ) ( - 1 ) )

const H5_SIZEOF_HADDR_T = H5_SIZEOF_INT64_T
const H5_PRINTF_HADDR_FMT = "%lu"
const HADDR_MAX = HADDR_UNDEF - 1
const H5_ITER_ERROR = -1
const H5_ITER_CONT = 0
const H5_ITER_STOP = 1
const htri_t = Cint
const hssize_t = Clonglong

@cenum H5_iter_order_t::Int32 begin
    H5_ITER_UNKNOWN = -1
    H5_ITER_INC = 0
    H5_ITER_DEC = 1
    H5_ITER_NATIVE = 2
    H5_ITER_N = 3
end

@cenum H5_index_t::Int32 begin
    H5_INDEX_UNKNOWN = -1
    H5_INDEX_NAME = 0
    H5_INDEX_CRT_ORDER = 1
    H5_INDEX_N = 2
end


const H5Acreate_vers = 2
const H5Acreate = H5Acreate2
const H5Aiterate_vers = 2
const H5Aiterate = H5Aiterate2
const H5A_operator_t = H5A_operator2_t
const H5Dcreate_vers = 2
const H5Dcreate = H5Dcreate2
const H5Dopen_vers = 2
const H5Dopen = H5Dopen2
const H5Eclear_vers = 2
const H5Eclear = H5Eclear2
const H5Eget_auto_vers = 2
const H5Eget_auto = H5Eget_auto2
const H5Eprint_vers = 2
const H5Eprint = H5Eprint2
const H5Epush_vers = 2
const H5Epush = H5Epush2
const H5Eset_auto_vers = 2
const H5Eset_auto = H5Eset_auto2
const H5Ewalk_vers = 2
const H5Ewalk = H5Ewalk2
const H5E_error_t = H5E_error2_t
const H5E_walk_t = H5E_walk2_t
const H5Gcreate_vers = 2
const H5Gcreate = H5Gcreate2
const H5Gopen_vers = 2
const H5Gopen = H5Gopen2
const H5Pget_filter_vers = 2
const H5Pget_filter = H5Pget_filter2
const H5Pget_filter_by_id_vers = 2
const H5Pget_filter_by_id = H5Pget_filter_by_id2
const H5Pinsert_vers = 2
const H5Pinsert = H5Pinsert2
const H5Pregister_vers = 2
const H5Pregister = H5Pregister2
const H5Rget_obj_type_vers = 2
const H5Rget_obj_type = H5Rget_obj_type2
const H5Tarray_create_vers = 2
const H5Tarray_create = H5Tarray_create2
const H5Tcommit_vers = 2
const H5Tcommit = H5Tcommit2
const H5Tget_array_dims_vers = 2
const H5Tget_array_dims = H5Tget_array_dims2
const H5Topen_vers = 2
const H5Topen = H5Topen2
const H5E_auto_t_vers = 2
const H5E_auto_t = H5E_auto2_t
const H5Z_class_t_vers = 2
const H5Z_class_t = H5Z_class2_t
