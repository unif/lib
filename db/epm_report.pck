CREATE OR REPLACE PACKAGE epm_report AS
    TYPE refc IS REF CURSOR;

    PROCEDURE p_print_sql(p_txt VARCHAR2);

    FUNCTION f_split_str(p_str VARCHAR2, p_diyision VARCHAR2, p_seq INT)
        RETURN VARCHAR2;

    PROCEDURE p_rows_column(p_table      IN VARCHAR2,
                            p_keep_cols  IN VARCHAR2,
                            p_pivot_cols IN VARCHAR2,
                            p_where      IN VARCHAR2 DEFAULT NULL,
                            p_refc       IN OUT refc);

    PROCEDURE p_rows_column_real(p_table     IN VARCHAR2,
                                 p_keep_cols IN VARCHAR2,
                                 p_pivot_col IN VARCHAR2,
                                 p_pivot_val IN VARCHAR2,
                                 p_where     IN VARCHAR2 DEFAULT NULL,
                                 p_refc      IN OUT refc);
    FUNCTION f_rows_to_columns(p_table     IN VARCHAR2,
                               p_keep_cols IN VARCHAR2,
                               p_pivot_col IN VARCHAR2,
                               p_pivot_val IN VARCHAR2,
                               p_where     IN VARCHAR2 DEFAULT NULL)
        RETURN CLOB;
    PROCEDURE p_rows_to_columns(
                                --
                                --用途:
                                -- 不固定多行转多列
                                -- 
                                --参数:
                                --  p_table:     表名，可以多个，并带别名
                                --  p_keep_cols:  保留列 
                                --  p_pivot_col: 透视表
                                --  p_pivot_val: 值列
                                --举例:
                                --
                                p_table           IN VARCHAR2,
                                p_keep_cols       IN VARCHAR2,
                                p_pivot_col       IN VARCHAR2,
                                p_pivot_val       IN VARCHAR2,
                                p_where           IN VARCHAR2 DEFAULT NULL,
                                p_pivot_label_sql IN VARCHAR2 DEFAULT NULL,
                                p_order_by        IN VARCHAR2 DEFAULT NULL,
                                p_aggr            IN VARCHAR2 DEFAULT 'max',
                                p_sql             IN OUT CLOB,
                                p_labels          IN OUT VARCHAR2);
    --
    PROCEDURE p_pivot_row(p_table           IN VARCHAR2,
                          p_keep_cols       IN VARCHAR2,
                          p_pivot_col       IN VARCHAR2,
                          p_pivot_val       IN VARCHAR2,
                          p_where           IN VARCHAR2 DEFAULT NULL,
                          p_pivot_label_sql IN VARCHAR2 DEFAULT NULL,
                          p_order_by        IN VARCHAR2 DEFAULT NULL,
                          p_sql             IN OUT CLOB,
                          p_labels          IN OUT VARCHAR2);
    /*-------------------------------------------------------------
    * 以table表格形式输出sql结果
    *
    */
    PROCEDURE p_print_table(p_sql           IN CLOB,
                            p_labels        IN VARCHAR2,
                            p_request       IN VARCHAR2 DEFAULT 'GO',
                            p_filename      IN VARCHAR2 DEFAULT 'Report',
                            p_table_class   IN VARCHAR2 DEFAULT 'uReport',
                            p_null_text     IN VARCHAR2 DEFAULT '-',
                            p_num_col_index IN PLS_INTEGER DEFAULT 3);
    PROCEDURE p_print_style(p_request_in IN VARCHAR2 DEFAULT 'EXPORT');
    /*-------------------------------------------------------------
    * 清空临时表
    *
    */
    PROCEDURE clear_temp(p_main_codes IN VARCHAR2);
    PROCEDURE clear_gt_temp(p_main_codes IN VARCHAR2);
    /*-------------------------------------------------------------
    * 汇总损益表blm10R2、制造成本表blm70R1、库存月报blm80R1
    *
    */
    PROCEDURE p_rep_801_a(p_yyyy        IN VARCHAR2,
                          p_factnos     IN VARCHAR2,
                          p_rep_kind    IN VARCHAR2,
                          p_table_class IN VARCHAR2 DEFAULT 'uReport',
                          p_request     IN VARCHAR2 DEFAULT 'GO',
                          p_filename    IN VARCHAR2 DEFAULT 'REPORT');
    PROCEDURE p_rep_801_b(p_yyyy        IN VARCHAR2,
                          p_groups      IN VARCHAR2,
                          p_rep_kind    IN VARCHAR2,
                          p_table_class IN VARCHAR2 DEFAULT 'uReport',
                          p_request     IN VARCHAR2 DEFAULT 'GO',
                          p_filename    IN VARCHAR2 DEFAULT 'REPORT');
    /*-------------------------------------------------------------
    * 部别损益表blm10R0
    *
    */
    PROCEDURE p_rep_801_c(p_yyyy        IN VARCHAR2,
                          p_factnos     IN VARCHAR2,
                          p_rep_kind    IN VARCHAR2,
                          p_type        IN VARCHAR2,
                          p_table_class IN VARCHAR2 DEFAULT 'uReport',
                          p_request     IN VARCHAR2 DEFAULT 'GO',
                          p_filename    IN VARCHAR2 DEFAULT 'REPORT');
    PROCEDURE p_rep_801_d(p_year        IN VARCHAR2,
                          p_detc_code   IN VARCHAR2,
                          p_rep_kind    IN VARCHAR2,
                          p_version     IN VARCHAR2,
                          p_table_class IN VARCHAR2 DEFAULT 'uReport',
                          p_request     IN VARCHAR2 DEFAULT 'GO',
                          p_filename    IN VARCHAR2 DEFAULT 'REPORT');

    ------------------------------------------------------------------------
    -- 名    称：refresh_dw100
    -- 内容摘要：收入汇总
    -- 创建者  ：Cuiyingming
    -- 创建时间: 2013/10/13
    -- 被访问表：blm100t0等   
    -- 被插入表: t_dw100     
    -- 输    入：p_yyyy        年度
    --           p_version     版本          

    PROCEDURE refresh_dw100(p_yyyy IN VARCHAR2, p_version IN VARCHAR2);
    ------------------------------------------------------------------------
    -- 名    称：refresh_dw200
    -- 内容摘要：费用汇总
    -- 创建者  ：Cuiyingming
    -- 创建时间: 2013/10/30
    -- 被访问表：blm100t0等   
    -- 被插入表: t_dw100     
    -- 输    入：p_yyyy        年度
    --           p_version     版本          

    PROCEDURE refresh_dw200(p_yyyy IN VARCHAR2, p_version IN VARCHAR2);
    ------------------------------------------------------------------------
    -- 名    称：refresh_dw600
    -- 内容摘要：输出排产综合明细表
    -- 创建者  ：Cuiyingming
    -- 创建时间: 2013/10/13
    -- 被访问表：blm600t1等    
    -- 被插入表: t_dw600    
    -- 输    入：p_yyyy        年度
    -- 版    本：p_version

    PROCEDURE refresh_dw600(p_yyyy IN VARCHAR2, p_version IN VARCHAR2);

    -------------------------------------------------------------------------
    -- 名    称：show_report_aps_1
    -- 内容摘要：输出排产综合明细表
    -- 调    用：p_print_meta
    --           p_print_head
    --           p_print_downloadlink
    --           p_stop_print             
    -- 被调用  ：
    -- 创建者  ：Cuiyingming
    -- 创建时间: 2013/10/11
    -- 被访问表：blm100t0,blm600t1等

    -- 输    入：p_yyyy        年度
    --           p_version     版本
    --           p_area        区域
    --           p_factno      子公司
    --           p_request     请求
    --           p_filename    文件名
    --           p_table_class 报表css类名 

    PROCEDURE show_report_aps_1(p_yyyy        IN VARCHAR2,
                                p_version     IN VARCHAR2,
                                p_area        IN VARCHAR2,
                                p_factno      IN VARCHAR2,
                                p_clus        IN VARCHAR2,
                                p_request     IN VARCHAR2 DEFAULT 'GO',
                                p_filename    IN VARCHAR2 DEFAULT 'Report',
                                p_table_class IN VARCHAR2 DEFAULT 'uReport');
    -------------------------------------------------------------------------
    -- 名    称：show_report_aps_2
    -- 内容摘要：输出排产调整平台报表
    -- 调    用：p_print_meta
    --           p_print_head
    --           p_print_downloadlink
    --           p_stop_print             
    -- 被调用  ：
    -- 创建者  ：Cuiyingming
    -- 创建时间: 2013/10/18
    -- 被访问表：blm100t0,blm600t1等

    -- 输    入：p_yyyy        年度
    --           p_area        区域
    --           p_factno      子公司
    --           p_request     请求
    --           p_filename    文件名
    --           p_table_class 报表css类名                             
    PROCEDURE show_report_aps_2(p_yyyymm      IN VARCHAR2,
                                p_sum_item    IN VARCHAR2,
                                p_aps         IN epm_aps.type_aps,
                                p_request     IN VARCHAR2 DEFAULT 'GO',
                                p_filename    IN VARCHAR2 DEFAULT 'Report.xls',
                                p_table_class IN VARCHAR2 DEFAULT 'uReport');
    -------------------------------------------------------------------------
    -- 名    称：show_report_aps_3
    -- 内容摘要：进出明细表
    -- 调    用：p_print_meta
    --           p_print_head
    --           p_print_downloadlink
    --           p_stop_print             
    -- 被调用  ：
    -- 创建者  ：Cuiyingming
    -- 创建时间: 2013/10/29
    -- 被访问表：blm100t0,blm600t1等

    -- 输    入：p_yyyy        年度
    --           p_version      版本
    --           p_area        区域
    --           p_factno      子公司
    --           p_request     请求
    --           p_filename    文件名
    --           p_table_class 报表css类名  
    PROCEDURE show_report_aps_3(p_yyyy        IN VARCHAR2,
                                p_version     IN VARCHAR2,
                                p_yyyymm      IN VARCHAR2,
                                p_area        IN VARCHAR2,
                                p_fact        IN VARCHAR2 DEFAULT NULL,
                                p_clus        IN VARCHAR2 DEFAULT NULL,
                                p_request     IN VARCHAR2 DEFAULT 'GO',
                                p_filename    IN VARCHAR2 DEFAULT 'Report',
                                p_table_class IN VARCHAR2 DEFAULT 'uReport');
    -------------------------------------------------------------------------
    -- 名    称：show_report_aps_4
    -- 内容摘要：进出明细表 - 导出全部                             
    PROCEDURE show_report_aps_4(p_yyyy        IN VARCHAR2,
                                p_version     IN VARCHAR2,
                                p_request     IN VARCHAR2 DEFAULT 'GO',
                                p_filename    IN VARCHAR2 DEFAULT 'Report',
                                p_table_class IN VARCHAR2 DEFAULT 'uReport');
END;
/
CREATE OR REPLACE PACKAGE BODY epm_report AS
    --   
    g_page    NUMBER := apex_application.g_flow_step_id;
    g_session VARCHAR2(100) := apex_application.g_instance;
    g_app     NUMBER := apex_application.g_flow_id;
    g_user    VARCHAR2(100) := apex_application.g_user;

    --
    --返回用TD包裹的内容
    FUNCTION wrap_cell(p_text IN VARCHAR2, p_attr IN VARCHAR2 DEFAULT NULL)
        RETURN VARCHAR2 IS
    BEGIN
        RETURN '<td ' || p_attr || '>' || p_text || '</td>';
    END;

    --返回用TD包裹的内容
    FUNCTION wrap_cell_num(p_text IN VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        RETURN wrap_cell(p_text => p_text, p_attr => 'class="number"');
    END;

    --
    --
    PROCEDURE p_print_sql(p_txt VARCHAR2) IS
        v_len INT;
    BEGIN
        v_len := length(p_txt);
        -- 分批输出，避免ORA-06502
        FOR i IN 1 .. v_len / 250 + 1 LOOP
            dbms_output.put_line(substrb(p_txt, (i - 1) * 250 + 1, 250));
        END LOOP;
    END;

    FUNCTION f_split_str(p_str VARCHAR2, p_diyision VARCHAR2, p_seq INT)
        RETURN VARCHAR2 IS
        v_first INT;
        v_last  INT;
    BEGIN
        IF p_seq < 1 THEN
            RETURN NULL;
        END IF;
        IF p_seq = 1 THEN
            IF instr(p_str, p_diyision, 1, p_seq) = 0 THEN
                RETURN p_str;
            ELSE
                RETURN substr(p_str, 1, instr(p_str, p_diyision, 1) - 1);
            END IF;
        ELSE
            v_first := instr(p_str, p_diyision, 1, p_seq - 1);
            v_last  := instr(p_str, p_diyision, 1, p_seq);
            IF (v_last = 0) THEN
                IF (v_first > 0) THEN
                    RETURN substr(p_str, v_first + 1);
                ELSE
                    RETURN NULL;
                END IF;
            ELSE
                RETURN substr(p_str, v_first + 1, v_last - v_first - 1);
            END IF;
        END IF;
    END f_split_str;

    PROCEDURE p_rows_column(p_table      IN VARCHAR2,
                            p_keep_cols  IN VARCHAR2,
                            p_pivot_cols IN VARCHAR2,
                            p_where      IN VARCHAR2 DEFAULT NULL,
                            p_refc       IN OUT refc) IS
        v_sql VARCHAR2(4000);
        TYPE v_keep_ind_by IS TABLE OF VARCHAR2(4000) INDEX BY BINARY_INTEGER;
        v_keep v_keep_ind_by;
    
        TYPE v_pivot_ind_by IS TABLE OF VARCHAR2(4000) INDEX BY BINARY_INTEGER;
        v_pivot v_pivot_ind_by;
    
        v_keep_cnt   INT;
        v_pivot_cnt  INT;
        v_max_cols   INT;
        v_partition  VARCHAR2(4000);
        v_partition1 VARCHAR2(4000);
        v_partition2 VARCHAR2(4000);
    BEGIN
        v_keep_cnt  := length(p_keep_cols) -
                       length(REPLACE(p_keep_cols, ',')) + 1;
        v_pivot_cnt := length(p_pivot_cols) -
                       length(REPLACE(p_pivot_cols, ',')) + 1;
        FOR i IN 1 .. v_keep_cnt LOOP
            v_keep(i) := f_split_str(p_keep_cols, ',', i);
        END LOOP;
        FOR j IN 1 .. v_pivot_cnt LOOP
            v_pivot(j) := f_split_str(p_pivot_cols, ',', j);
        END LOOP;
        v_sql := 'select max(count(*)) from ' || p_table || ' group by ';
        FOR i IN 1 .. v_keep.last LOOP
            v_sql := v_sql || v_keep(i) || ',';
        END LOOP;
        v_sql := rtrim(v_sql, ',');
        EXECUTE IMMEDIATE v_sql
            INTO v_max_cols;
        v_partition := 'select ';
        FOR x IN 1 .. v_keep.count LOOP
            v_partition1 := v_partition1 || v_keep(x) || ',';
        END LOOP;
        FOR y IN 1 .. v_pivot.count LOOP
            v_partition2 := v_partition2 || v_pivot(y) || ',';
        END LOOP;
        v_partition1 := rtrim(v_partition1, ',');
        v_partition2 := rtrim(v_partition2, ',');
        v_partition  := v_partition || v_partition1 || ',' || v_partition2 ||
                        ', row_number() over (partition by ' ||
                        v_partition1 || ' order by ' || v_partition2 ||
                        ') rn from ' || p_table;
        v_partition  := rtrim(v_partition, ',');
        v_sql        := 'select ';
        FOR i IN 1 .. v_keep.count LOOP
            v_sql := v_sql || v_keep(i) || ',';
        END LOOP;
        FOR i IN 1 .. v_max_cols LOOP
            FOR j IN 1 .. v_pivot.count LOOP
                v_sql := v_sql || ' max(decode(rn,' || i || ',' ||
                         v_pivot(j) || ',null))' || v_pivot(j) || '_' || i || ',';
            END LOOP;
        END LOOP;
        IF p_where IS NOT NULL THEN
            v_sql := rtrim(v_sql, ',') || ' from (' || v_partition || ' ' ||
                     p_where || ') group by ';
        ELSE
            v_sql := rtrim(v_sql, ',') || ' from (' || v_partition ||
                     ') group by ';
        END IF;
        FOR i IN 1 .. v_keep.count LOOP
            v_sql := v_sql || v_keep(i) || ',';
        END LOOP;
        v_sql := rtrim(v_sql, ',');
        p_print_sql(v_sql);
        OPEN p_refc FOR v_sql;
    EXCEPTION
        WHEN OTHERS THEN
            OPEN p_refc FOR
                SELECT 'x' FROM dual WHERE 0 = 1;
    END;

    PROCEDURE p_rows_column_real(p_table     IN VARCHAR2,
                                 p_keep_cols IN VARCHAR2,
                                 p_pivot_col IN VARCHAR2,
                                 p_pivot_val IN VARCHAR2,
                                 p_where     IN VARCHAR2 DEFAULT NULL,
                                 p_refc      IN OUT refc) IS
        v_sql VARCHAR2(4000);
        TYPE v_keep_ind_by IS TABLE OF VARCHAR2(4000) INDEX BY BINARY_INTEGER;
        v_keep v_keep_ind_by;
        TYPE v_pivot_ind_by IS TABLE OF VARCHAR2(4000) INDEX BY BINARY_INTEGER;
        v_pivot    v_pivot_ind_by;
        v_keep_cnt INT;
        v_group_by VARCHAR2(2000);
    BEGIN
        -- 列数
        v_keep_cnt := length(p_keep_cols) -
                      length(REPLACE(p_keep_cols, ',')) + 1;
        -- 列转数组
        FOR i IN 1 .. v_keep_cnt LOOP
            v_keep(i) := f_split_str(p_keep_cols, ',', i);
        END LOOP;
        v_sql := 'select ' || 'cast(' || p_pivot_col ||
                 ' as varchar2(200)) as ' || p_pivot_col || ' from ' ||
                 p_table || ' group by ' || p_pivot_col;
        EXECUTE IMMEDIATE v_sql BULK COLLECT
            INTO v_pivot;
    
        --  
        FOR i IN 1 .. v_keep.count LOOP
            v_group_by := v_group_by || v_keep(i) || ',';
        END LOOP;
    
        v_group_by := rtrim(v_group_by, ',');
        v_sql      := 'select ' || v_group_by || ',';
    
        FOR x IN 1 .. v_pivot.count LOOP
            v_sql := v_sql || ' max(decode(' || p_pivot_col || ',' ||
                     chr(39) || v_pivot(x) || chr(39) || ',' || p_pivot_val ||
                     ',null)) as "' || v_pivot(x) || '",';
        END LOOP;
        v_sql := rtrim(v_sql, ',');
        IF p_where IS NOT NULL THEN
            v_sql := v_sql || ' from ' || p_table || p_where ||
                     ' group by ' || v_group_by;
        ELSE
            v_sql := v_sql || ' from ' || p_table || ' group by ' ||
                     v_group_by;
        END IF;
        p_print_sql(v_sql);
        OPEN p_refc FOR v_sql;
    EXCEPTION
        WHEN OTHERS THEN
            OPEN p_refc FOR
                SELECT 'x' FROM dual WHERE 0 = 1;
    END;
    --
    FUNCTION f_rows_to_columns(p_table     IN VARCHAR2,
                               p_keep_cols IN VARCHAR2,
                               p_pivot_col IN VARCHAR2,
                               p_pivot_val IN VARCHAR2,
                               p_where     IN VARCHAR2 DEFAULT NULL)
        RETURN CLOB IS
        v_sql CLOB;
        TYPE v_keep_ind_by IS TABLE OF VARCHAR2(4000) INDEX BY BINARY_INTEGER;
        v_keep v_keep_ind_by;
        TYPE v_pivot_ind_by IS TABLE OF VARCHAR2(4000) INDEX BY BINARY_INTEGER;
        v_pivot    v_pivot_ind_by;
        v_keep_cnt INT;
        v_group_by VARCHAR2(2000);
    
    BEGIN
        -- 列数
        v_keep_cnt := length(p_keep_cols) -
                      length(REPLACE(p_keep_cols, ',')) + 1;
        -- 列转数组
        FOR i IN 1 .. v_keep_cnt LOOP
            v_keep(i) := f_split_str(p_keep_cols, ',', i);
        END LOOP;
        v_sql := 'select ' || p_pivot_col || ' from ' || p_table || ' ' ||
                 p_where || ' group by ' || p_pivot_col || ' order by ' ||
                 p_pivot_col;
    
        EXECUTE IMMEDIATE v_sql BULK COLLECT
            INTO v_pivot;
    
        --  
        FOR i IN 1 .. v_keep.count LOOP
            v_group_by := v_group_by || v_keep(i) || ',';
        END LOOP;
    
        v_group_by := rtrim(v_group_by, ',');
        v_sql      := 'select ' || v_group_by || ',';
    
        -- 透视的列
        FOR x IN 1 .. v_pivot.count LOOP
        
            v_sql := v_sql || chr(39) || '<td>' || chr(39) ||
                     '|| max(decode(' || p_pivot_col || ',' || chr(39) ||
                     v_pivot(x) || chr(39) || ',' || p_pivot_val ||
                     ',null)) ' || '||' || chr(39) || '</td>' || chr(39) || '||';
        END LOOP;
        --
        v_sql := rtrim(v_sql, ',');
        IF p_where IS NOT NULL THEN
            v_sql := v_sql || ' from ' || p_table || ' ' || p_where ||
                     ' group by ' || v_group_by;
        ELSE
            v_sql := v_sql || ' from ' || p_table || ' group by ' ||
                     v_group_by;
        END IF;
        RETURN v_sql;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN SQLERRM || '-' || v_sql;
    END f_rows_to_columns;
    --
    PROCEDURE p_rows_to_columns(p_table           IN VARCHAR2,
                                p_keep_cols       IN VARCHAR2,
                                p_pivot_col       IN VARCHAR2,
                                p_pivot_val       IN VARCHAR2,
                                p_where           IN VARCHAR2 DEFAULT NULL,
                                p_pivot_label_sql IN VARCHAR2 DEFAULT NULL,
                                p_order_by        IN VARCHAR2 DEFAULT NULL,
                                p_aggr            IN VARCHAR2 DEFAULT 'max',
                                p_sql             IN OUT CLOB,
                                p_labels          IN OUT VARCHAR2) IS
        v_sql CLOB;
        TYPE v_keep_ind_by IS TABLE OF VARCHAR2(4000) INDEX BY BINARY_INTEGER;
        v_keep v_keep_ind_by;
        TYPE v_pivot_ind_by IS TABLE OF VARCHAR2(4000) INDEX BY BINARY_INTEGER;
        v_pivot       v_pivot_ind_by;
        v_keep_cnt    INT;
        v_group_by    VARCHAR2(2000);
        v_pivot_label VARCHAR2(100);
        v_bln         BOOLEAN;
    
    BEGIN
        -- 列数
        v_keep_cnt := length(p_keep_cols) -
                      length(REPLACE(p_keep_cols, ',')) + 1;
        -- 列转数组
        FOR i IN 1 .. v_keep_cnt LOOP
            v_keep(i) := f_split_str(p_keep_cols, ',', i);
        END LOOP;
        v_sql := 'select ' || p_pivot_col || ' from ' || p_table || ' ' ||
                 p_where || ' group by ' || p_pivot_col || ' order by ' ||
                 p_pivot_col;
    
        EXECUTE IMMEDIATE v_sql BULK COLLECT
            INTO v_pivot;
    
        --  
        FOR i IN 1 .. v_keep.count LOOP
            v_group_by := v_group_by || v_keep(i) || ',';
        END LOOP;
    
        v_group_by := rtrim(v_group_by, ',');
        v_sql      := 'select ' || v_group_by || ',';
    
        -- 透视的列
        v_bln := CASE
                     WHEN p_pivot_label_sql IS NOT NULL THEN
                      TRUE
                     ELSE
                      FALSE
                 END;
        FOR x IN 1 .. v_pivot.count LOOP
            v_pivot_label := NULL;
            IF v_bln THEN
                BEGIN
                    EXECUTE IMMEDIATE p_pivot_label_sql
                        INTO v_pivot_label
                        USING v_pivot(x);
                    p_labels := p_labels ||
                                coalesce(v_pivot_label, v_pivot(x)) || ':';
                EXCEPTION
                    WHEN no_data_found THEN
                        p_labels := p_labels ||
                                    coalesce(v_pivot_label, v_pivot(x)) || ':';
                END;
            END IF;
        
            v_sql := v_sql || p_aggr || '(decode(' || p_pivot_col || ',' ||
                     chr(39) || v_pivot(x) || chr(39) || ',' || p_pivot_val ||
                     ','''')) ' || ' as "' || v_pivot(x) /*coalesce(v_pivot_label, v_pivot(x))*/
                     || '"' || ',';
        END LOOP;
        --
        v_sql := rtrim(rtrim(v_sql, ','), '||');
        IF p_where IS NOT NULL THEN
            v_sql := v_sql || ' from ' || p_table || ' ' || p_where ||
                     ' group by ' || v_group_by;
        ELSE
            v_sql := v_sql || ' from ' || p_table || ' group by ' ||
                     v_group_by;
        END IF;
    
        -- order by
        v_sql := v_sql || CASE
                     WHEN p_order_by IS NOT NULL THEN
                      ' order by ' || p_order_by
                     ELSE
                      NULL
                 END;
        -- 输出
        p_sql := v_sql;
    
    EXCEPTION
        WHEN OTHERS THEN
            epm_public.trace_error(p_txt => substr(p_sql, 1, 4000), p_src => 'epm_report.p_rows_to_columns');
            raise_application_error(-20001, 'p_rows_to_columns：' || SQLERRM);
    END p_rows_to_columns;
    --
    PROCEDURE p_pivot_row(p_table           IN VARCHAR2,
                          p_keep_cols       IN VARCHAR2,
                          p_pivot_col       IN VARCHAR2,
                          p_pivot_val       IN VARCHAR2,
                          p_where           IN VARCHAR2 DEFAULT NULL,
                          p_pivot_label_sql IN VARCHAR2 DEFAULT NULL,
                          p_order_by        IN VARCHAR2 DEFAULT NULL,
                          p_sql             IN OUT CLOB,
                          p_labels          IN OUT VARCHAR2) IS
        v_sql CLOB;
        -- type v_keep_ind_by is table of varchar2(4000) index by binary_integer;
        -- v_keep v_keep_ind_by;
        TYPE v_pivot_ind_by IS TABLE OF VARCHAR2(4000) INDEX BY BINARY_INTEGER;
        v_pivot v_pivot_ind_by;
        -- v_keep_cnt    int;
        -- v_group_by    varchar2(2000);
        v_pivot_label VARCHAR2(100);
        v_bln         BOOLEAN;
    
        --
        l_sep       VARCHAR2(40) := '||''</TD><TD>''||';
        l_val_r     VARCHAR2(40) := '||''</TD><TD align=right>''||';
        l_keep_cols VARCHAR2(1000);
    BEGIN
        l_keep_cols := REPLACE(p_keep_cols, ',', l_sep);
        l_keep_cols := '''<TR><TD>''||' || l_keep_cols;
    
        v_sql := 'select ' || p_pivot_col || ' from ' || p_table || ' ' ||
                 p_where || ' group by ' || p_pivot_col || ' order by ' ||
                 p_pivot_col;
    
        EXECUTE IMMEDIATE v_sql BULK COLLECT
            INTO v_pivot;
    
        v_sql := 'select ' || l_keep_cols || l_val_r;
    
        -- 透视的列
        v_bln := CASE
                     WHEN p_pivot_label_sql IS NOT NULL THEN
                      TRUE
                     ELSE
                      FALSE
                 END;
        FOR x IN 1 .. v_pivot.count LOOP
        
            IF v_bln THEN
                EXECUTE IMMEDIATE p_pivot_label_sql
                    INTO v_pivot_label
                    USING v_pivot(x);
                p_labels := p_labels || coalesce(v_pivot_label, v_pivot(x)) || ':';
            END IF;
        
            v_sql := v_sql || 'max(decode(' || p_pivot_col || ',' ||
                     chr(39) || v_pivot(x) || chr(39) || ',' || p_pivot_val ||
                     ',null)) ' || l_val_r;
        END LOOP;
        --
        v_sql := rtrim(v_sql, l_val_r) || '||''</TD></TR>''';
    
        IF p_where IS NOT NULL THEN
            v_sql := v_sql || ' from ' || p_table || ' ' || p_where ||
                     ' group by ' || p_keep_cols;
        ELSE
            v_sql := v_sql || ' from ' || p_table || ' group by ' ||
                     p_keep_cols;
        END IF;
    
        -- order by 
        v_sql := v_sql || ' order by ' || p_order_by;
        -- OUT 
        p_sql := v_sql;
    EXCEPTION
        WHEN OTHERS THEN
            raise_application_error(-20001, 'p_pivot_row：' || SQLERRM);
    END p_pivot_row;
    --
    --
    PROCEDURE p_print_meta(p_request_in  IN VARCHAR2 DEFAULT 'EXPORT',
                           p_filename_in IN VARCHAR2) IS
    BEGIN
        IF p_request_in = 'EXPORT' THEN
            -- Set the MIME type
            owa_util.mime_header('application/octet', FALSE);
            -- Set the name of the file
            htp.p('Content-Disposition: attachment; filename="' ||
                  wwv_flow_utilities.escape_url(p_url => p_filename_in, p_url_charset => 'utf-8'));
        
            -- Close the HTTP Header
            owa_util.http_header_close;
        
        END IF;
    END;
    PROCEDURE p_print_head(p_request_in IN VARCHAR2 DEFAULT 'GO',
                           p_charset    IN VARCHAR2 DEFAULT 'UTF-8') IS -- GB2312内容中文乱码
    BEGIN
        htp.prn('<html><meta http-equiv="Content-Type" content="text/html"; charset="' ||
                p_charset || '"><head>');
        p_print_style(p_request_in => p_request_in);
        htp.prn('</head>');
    END;

    --
    -- 
    PROCEDURE p_print_downloadlink(p_request_in VARCHAR2 DEFAULT 'GO') IS
    BEGIN
        IF p_request_in = 'GO' THEN
            htp.prn('<div class="uReportDownloadLinks mgt-10"><a href="f?p=' ||
                    g_app || ':' || g_page || ':' || g_session ||
                    ':EXPORT:NO:::">下载报表</a></div>');
        END IF;
    END;
    --
    PROCEDURE p_stop_print(p_request_in IN VARCHAR2 DEFAULT 'EXPORT') IS
    BEGIN
        IF p_request_in = 'EXPORT' THEN
            htmldb_application.g_unrecoverable_error := TRUE;
        END IF;
    END;
    --
    PROCEDURE p_print_style(p_request_in IN VARCHAR2 DEFAULT 'EXPORT') IS
    BEGIN
        IF p_request_in = 'EXPORT' THEN
            htp.prn('<style>
       .uReport{border-collapse:collapse
       }
       .uReport th{background-color:#eee;
                border-bottom:#ddd 0.5pt solid;
                border-right:#ddd 0.5pt solid;
                color:#555;
                padding:8px;
                height:20pt;
       }
       .uReport td{
                border:#ddd 0.5pt solid;
                padding:0 6px;
       }
       .uReport th.r-header{
                background-color:#fff;
                text-align:left;
                font:bold 14px;height:26pt}
       </style>');
        END IF;
    END;
    --
    PROCEDURE p_print_table(p_sql           IN CLOB,
                            p_labels        IN VARCHAR2,
                            p_request       IN VARCHAR2 DEFAULT 'GO',
                            p_filename      IN VARCHAR2 DEFAULT 'Report',
                            p_table_class   IN VARCHAR2 DEFAULT 'uReport',
                            p_null_text     IN VARCHAR2 DEFAULT '-',
                            p_num_col_index IN PLS_INTEGER DEFAULT 3) AS
        q_cursor   INTEGER;
        column_val VARCHAR2(256);
        tretval    INTEGER;
        col_cnt    INTEGER;
    
        desc_t         dbms_sql.desc_tab;
        error_position INTEGER;
        v_label        apex_application_global.vc_arr2;
        l_class        VARCHAR2(40);
    BEGIN
    
        q_cursor := dbms_sql.open_cursor;
        dbms_sql.parse(q_cursor, p_sql, dbms_sql.v7);
        error_position := dbms_sql.last_error_position;
        dbms_sql.describe_columns(q_cursor, col_cnt, desc_t);
    
        FOR i IN 1 .. col_cnt LOOP
            dbms_sql.define_column(q_cursor, i, column_val, 255);
        END LOOP;
    
        tretval := dbms_sql.execute(q_cursor);
    
        v_label := apex_util.string_to_table(p_labels, ':');
    
        -- meta and head
        p_print_meta(p_request_in => p_request,
                     
                     p_filename_in => p_filename);
        p_print_head(p_request_in => p_request);
    
        htp.prn('<table class="' || p_table_class || '">');
    
        -- 标签
        htp.prn('<thead><tr>');
        FOR j IN 1 .. v_label.count LOOP
            htp.prn('<th>' || v_label(j) || '</th>');
        END LOOP;
        htp.prn('</tr></thead>');
    
        -- 数量
        LOOP
            -- 行循环
            tretval := dbms_sql.fetch_rows(q_cursor);
            IF tretval = 0 THEN
                EXIT;
            END IF;
            htp.prn('<tr>');
        
            FOR i IN 1 .. col_cnt LOOP
                -- 列循环
                dbms_sql.column_value(q_cursor, i, column_val);
                -- desc_t(i).col_name
                l_class := CASE
                               WHEN i >= p_num_col_index THEN
                                ' class="number"'
                               ELSE
                                NULL
                           END;
                htp.prn('<td ' || l_class || '>' ||
                        coalesce(column_val, p_null_text) || '</td>');
            END LOOP;
        
            htp.prn('</tr>');
        
        END LOOP;
        htp.prn('</table>');
    
        --
        p_print_downloadlink(p_request_in => p_request);
        -- 
        htp.prn('</html>');
        p_stop_print(p_request_in => p_request);
    
    EXCEPTION
    
        WHEN OTHERS THEN
            error_position := dbms_sql.last_error_position;
            raise_application_error(-20001, SQLERRM || ' Error at ' ||
                                     error_position);
    END;
    --
    PROCEDURE p_return_col_grp(p_rep_kind     IN VARCHAR2,
                               p_keep_col_num IN OUT VARCHAR2,
                               p_keep_header  IN OUT VARCHAR2,
                               p_group_header IN OUT VARCHAR2,
                               p_type         IN VARCHAR2) IS
    BEGIN
        IF p_rep_kind IS NOT NULL THEN
            SELECT fattr01, fattr02, fattr03
              INTO p_keep_col_num, p_keep_header, p_group_header
              FROM t_item
             WHERE fno = p_rep_kind
               AND ftype = 2166
               AND fkind = p_type;
        END IF;
    END;
    --
    PROCEDURE clear_temp(p_main_codes IN VARCHAR2) IS
        PRAGMA AUTONOMOUS_TRANSACTION;
        vc apex_application_global.vc_arr2;
    BEGIN
        /*DELETE FROM blm_temp
        WHERE instr(chr(44) || p_main_codes || chr(44),
                    chr(44) || main_code || chr(44)) > 0
          AND session_id = g_session;*/
        vc := apex_util.string_to_table(p_main_codes, ',');
        FOR i IN 1 .. vc.count LOOP
            DELETE FROM blm_temp
             WHERE main_code = vc(i)
               AND session_id = g_session;
        END LOOP;
    
        COMMIT;
    END clear_temp;
    --
    PROCEDURE clear_gt_temp(p_main_codes IN VARCHAR2) IS
        PRAGMA AUTONOMOUS_TRANSACTION;
        vc apex_application_global.vc_arr2;
    BEGIN
        vc := apex_util.string_to_table(p_main_codes, ',');
        FOR i IN 1 .. vc.count LOOP
            DELETE FROM gt_temp WHERE main_code = vc(i);
        END LOOP;
        COMMIT;
    END clear_gt_temp;
    --
    PROCEDURE p_rep_801_a(p_yyyy        IN VARCHAR2,
                          p_factnos     IN VARCHAR2,
                          p_rep_kind    IN VARCHAR2,
                          p_table_class IN VARCHAR2 DEFAULT 'uReport',
                          p_request     IN VARCHAR2 DEFAULT 'GO',
                          p_filename    IN VARCHAR2 DEFAULT 'REPORT') IS
        l_str          VARCHAR2(4000) := NULL;
        l_keep_header  VARCHAR2(400);
        l_group_header VARCHAR2(400);
        l_keep_col_num NUMBER;
        l_value_cnt    NUMBER := 0;
        -- 子公司
        CURSOR c_fact IS
            SELECT a.branch_no AS factno,
                   '公司名称：' || a.branch_name AS factname
              FROM erp_pub112t0 a
             WHERE branch_shape_no = '20'
               AND branch_level = '30'
               AND instr(':' || p_factnos || ':', ':' || branch_no || ':') > 0
               AND EXISTS (SELECT 1
                      FROM blm801t0 b
                     WHERE a.branch_no = b.factno
                       AND b.rep_kind = p_rep_kind);
        -- 透视列     
        CURSOR c_header(p_factno IN VARCHAR2) IS
        
            SELECT group_id,
                   group_name，count(1) over(ORDER BY 1) + l_keep_col_num AS cnt
              FROM blm801t0
             WHERE rep_kind = p_rep_kind
               AND factno = p_factno
               AND yyyy = p_yyyy
             GROUP BY group_id, group_name
             ORDER BY 1;
        -- 列标签   
        CURSOR c_keep_cols(p_factno IN VARCHAR2) IS
            SELECT detc_code, detc_code AS detc_name, rep_branch,
                   rep_branch AS branch_name, rep_seq_no, item_name
              FROM blm801t0
             WHERE rep_kind = p_rep_kind
               AND yyyy = p_yyyy
               AND factno = p_factno
             GROUP BY detc_code, rep_branch, rep_seq_no, item_name
             ORDER BY detc_code, rep_branch, rep_seq_no;
        -- 值
        CURSOR c_values(p_factno     IN VARCHAR2,
                        p_detc_code  IN VARCHAR2,
                        p_rep_branch IN VARCHAR2,
                        p_rep_seq_no IN VARCHAR2) IS
            SELECT a.group_id, to_char(b.amt, '999G999G999G999D00') AS VALUE
              FROM (SELECT group_id, group_name
                       FROM blm801t0
                      WHERE rep_kind = p_rep_kind
                        AND factno = p_factno
                        AND yyyy = p_yyyy
                      GROUP BY group_id, group_name) a,
                   
                   (SELECT group_id, SUM(amt) AS amt
                       FROM blm801t0 b
                      WHERE b.rep_kind = p_rep_kind
                        AND b.factno = p_factno
                        AND yyyy = p_yyyy
                        AND b.rep_branch = p_rep_branch
                        AND b.detc_code = p_detc_code
                        AND (b.rep_seq_no = p_rep_seq_no OR
                            b.rep_seq_no IS NULL)
                      GROUP BY group_id) b
             WHERE a.group_id = b.group_id(+)
             ORDER BY 1;
    
    BEGIN
    
        -- meta and head
        p_print_meta(p_request_in => p_request, p_filename_in => p_filename);
        p_print_head(p_request_in => p_request);
    
        -- body
        htp.prn('<body>');
    
        -- 
        p_return_col_grp(p_rep_kind => p_rep_kind, p_keep_col_num => l_keep_col_num, p_keep_header => l_keep_header, p_group_header => l_group_header, p_type => 'A');
    
        FOR r_f IN c_fact LOOP
            -- 子公司
            EXIT WHEN c_fact%NOTFOUND;
            -- table Start
            htp.prn('<table class="' || p_table_class || '">');
        
            htp.prn('<thead>');
        
            FOR r_h IN c_header(r_f.factno) LOOP
                IF c_header%ROWCOUNT = 1 THEN
                    -- 子公司名称
                    htp.prn('<tr><th class="mOuter" colspan=' || r_h.cnt || '>' ||
                            r_f.factname || '</th></tr>');
                    -- 列标签分组
                    IF l_group_header IS NOT NULL THEN
                        htp.prn('<tr>' || l_group_header || '</tr>');
                    END IF;
                
                END IF;
                l_str := l_str || '<th>' || r_h.group_name || '</th>';
            END LOOP;
        
            l_str := l_keep_header || l_str; -- header标签
        
            htp.prn(l_str || '</thead>');
            l_str := NULL;
            -- thead End
        
            -- tbody Start
            htp.prn('<tbody>');
        
            FOR r_kc IN c_keep_cols(r_f.factno) LOOP
                l_str := '<tr><td>' || r_kc.detc_code || '</td>' || '<td>' ||
                         r_kc.detc_name || '</td>' || '<td>' ||
                         r_kc.rep_branch || '</td>' || '<td>' ||
                         r_kc.branch_name || '</td>' || CASE
                             WHEN r_kc.rep_seq_no IS NOT NULL THEN
                              '<td>' || r_kc.rep_seq_no || '</td><td><pre>' || r_kc.item_name ||
                              '</pre></td>'
                             ELSE
                              NULL
                         END;
                htp.prn(l_str);
                -- Keep Cols End 
                -- Values Start
                l_str := NULL;
                FOR r_v IN c_values(r_f.factno, r_kc.detc_code, r_kc.rep_branch, r_kc.rep_seq_no) LOOP
                    -- 透视字段
                    l_str := l_str || '<td align=right>' || r_v.value ||
                             '</td>';
                    -- 
                    l_value_cnt := l_value_cnt + 1;
                END LOOP;
                htp.prn(l_str || '</tr>');
                l_str := NULL;
            
            END LOOP;
            htp.prn('</tbody>');
            -- tbody End
            htp.prn('</table>');
        
        END LOOP;
    
        --
        IF l_value_cnt > 1 THEN
            p_print_downloadlink(p_request_in => p_request);
        END IF;
    
        -- Fact End
        htp.prn('</body></html>');
    
        -- stop print
        p_stop_print(p_request_in => p_request);
    END;
    --
    PROCEDURE p_rep_801_b(p_yyyy        IN VARCHAR2,
                          p_groups      IN VARCHAR2,
                          p_rep_kind    IN VARCHAR2,
                          p_table_class IN VARCHAR2 DEFAULT 'uReport',
                          p_request     IN VARCHAR2 DEFAULT 'GO',
                          p_filename    IN VARCHAR2 DEFAULT 'REPORT') IS
        l_str          VARCHAR2(4000) := NULL;
        l_keep_header  VARCHAR2(400);
        l_group_header VARCHAR2(400);
        l_keep_col_num NUMBER;
    
        -- 子公司
        CURSOR c_fact IS
            SELECT group_id AS groupno, group_name AS groupname
              FROM blm801t0
             WHERE rep_kind = p_rep_kind
               AND yyyy = p_yyyy
               AND instr(':' || p_groups || ':', ':' || group_id || ':') > 0
             GROUP BY group_id, group_name
             ORDER BY group_id;
        -- 透视列     
        CURSOR c_header(p_groupno IN VARCHAR2) IS
        
            SELECT a.factno,
                   b.branch_name AS factname，count(1) over(ORDER BY 1) + l_keep_col_num AS cnt
              FROM blm801t0 a, erp_pub112t0 b
             WHERE rep_kind = p_rep_kind
               AND yyyy = p_yyyy
               AND group_id = p_groupno
               AND a.factno = b.branch_no
               AND b.branch_shape_no = '20'
               AND b.branch_level = '30'
             GROUP BY a.factno, b.branch_name
             ORDER BY 1;
        -- 列标签   
        CURSOR c_keep_cols(p_groupno IN VARCHAR2) IS
            SELECT detc_code, detc_code AS detc_name,
                   --rep_branch,
                   --rep_branch as branch_name,
                   rep_seq_no, item_name
              FROM blm801t0
             WHERE rep_kind = p_rep_kind
               AND yyyy = p_yyyy
               AND group_id = p_groupno
             GROUP BY detc_code, rep_seq_no, item_name
             ORDER BY detc_code, rep_seq_no;
        -- 值
        CURSOR c_values(p_groupno    IN VARCHAR2,
                        p_detc_code  IN VARCHAR2,
                        p_rep_seq_no IN VARCHAR2) IS
            SELECT factno, to_char(SUM(amt), '999G999G999G999D00') AS VALUE
              FROM blm801t0 b
             WHERE b.rep_kind = p_rep_kind
               AND yyyy = p_yyyy
               AND b.detc_code = p_detc_code
               AND (b.rep_seq_no = p_rep_seq_no OR b.rep_seq_no IS NULL)
               AND b.group_id = p_groupno
             GROUP BY factno
             ORDER BY 1;
    
    BEGIN
    
        -- meta and head
        p_print_meta(p_request_in => p_request, p_filename_in => p_filename);
        p_print_head(p_request_in => p_request);
    
        -- body
        htp.prn('<body>');
    
        p_return_col_grp(p_rep_kind => p_rep_kind, p_keep_col_num => l_keep_col_num, p_keep_header => l_keep_header, p_group_header => l_group_header, p_type => 'B');
    
        FOR r_f IN c_fact LOOP
            -- 子公司
            EXIT WHEN c_fact%NOTFOUND;
            -- table Start
            htp.prn('<table class="' || p_table_class || '">');
        
            htp.prn('<thead>');
        
            FOR r_h IN c_header(r_f.groupno) LOOP
                IF c_header%ROWCOUNT = 1 THEN
                    -- 子公司名称
                    htp.prn('<tr><th class="mOuter" colspan=' || r_h.cnt || '>' ||
                            r_f.groupname || '</th></tr>');
                    -- 列标签分组
                    IF l_group_header IS NOT NULL THEN
                        htp.prn('<tr>' || l_group_header || '</tr>');
                    END IF;
                
                END IF;
                l_str := l_str || '<th>' || r_h.factname || '</th>';
            END LOOP;
        
            l_str := l_keep_header || l_str; -- header标签
        
            htp.prn(l_str || '</thead>');
            l_str := NULL;
            -- thead End
        
            -- tbody Start
            htp.prn('<tbody>');
        
            FOR r_kc IN c_keep_cols(r_f.groupno) LOOP
                l_str := '<tr><td>' || r_kc.detc_code || '</td>' || '<td>' ||
                         r_kc.detc_name || '</td>' || '<td>' ||
                         r_kc.rep_seq_no || '</td><td><pre>' ||
                         r_kc.item_name || '</pre></td>';
                htp.prn(l_str);
                -- Keep Cols End 
                -- Values Start
                l_str := NULL;
                FOR r_v IN c_values(r_f.groupno, r_kc.detc_code, r_kc.rep_seq_no) LOOP
                    -- 透视字段
                    l_str := l_str || '<td align=right>' || r_v.value ||
                             '</td>';
                END LOOP;
                htp.prn(l_str || '</tr>');
                l_str := NULL;
            
            END LOOP;
            htp.prn('</tbody>');
            -- tbody End
            htp.prn('</table>');
        
        END LOOP;
        -- Fact End
        htp.prn('</body></html>');
    
        -- stop print
        p_stop_print(p_request_in => p_request);
    END p_rep_801_b;
    --
    PROCEDURE p_rep_801_c(p_yyyy        IN VARCHAR2,
                          p_factnos     IN VARCHAR2,
                          p_rep_kind    IN VARCHAR2,
                          p_type        IN VARCHAR2,
                          p_table_class IN VARCHAR2 DEFAULT 'uReport',
                          p_request     IN VARCHAR2 DEFAULT 'GO',
                          p_filename    IN VARCHAR2 DEFAULT 'REPORT') IS
        l_sql          CLOB;
        l_labels       VARCHAR2(1000);
        l_row          VARCHAR2(4000);
        l_table        VARCHAR2(4000);
        l_curosr       SYS_REFCURSOR;
        l_keep_header  VARCHAR2(400);
        l_group_header VARCHAR2(400);
        l_keep_col_num NUMBER;
        l_value_cnt    NUMBER := 0;
    
        CURSOR c_fact IS
            SELECT a.branch_no AS factno, a.branch_name AS factname
              FROM erp_pub112t0 a
             WHERE branch_shape_no = '20'
               AND branch_level = '30'
               AND instr(':' || p_factnos || ':', ':' || branch_no || ':') > 0
               AND EXISTS (SELECT 1
                      FROM blm801t0 b
                     WHERE a.branch_no = b.factno
                       AND b.rep_kind = p_rep_kind);
    BEGIN
    
        -- meta and head
        p_print_meta(p_request_in => p_request, p_filename_in => p_filename);
        p_print_head(p_request_in => p_request);
    
        -- body
        htp.prn('<body>');
    
        p_return_col_grp(p_rep_kind => p_rep_kind, p_keep_col_num => l_keep_col_num, p_keep_header => l_keep_header, p_group_header => l_group_header, p_type => 'C');
    
        FOR r_fact IN c_fact LOOP
            l_labels := NULL;
            l_row    := NULL;
            l_table := CASE
                           WHEN p_type = 'DETC_CODE' THEN
                            ' (select 
                           a.yyyymm,
                           a.detc_code as bu_code,b.sku_nm as ch_name,
                           a.rep_branch,e.entityname,
                           a.rep_seq_no,''<pre>''||a.item_name||''</pre>'' as item_name,
                           a.group_id,
                           to_char(SUM(coalesce(a.amt, 0)),''999G999G999G999D00'') as amt
                      from blm801t0 a, sku b, blm_entity e
                     where a.rep_kind = ' || '''' ||
                            p_rep_kind || '''' || '
                       and a.detc_code = b.sku_no
                       and a.rep_branch = e.rep_banch
                       and a.yyyy = e.yyyy
                       and a.yyyy = ' || chr(39) ||
                            p_yyyy || chr(39) || '
                       and a.factno = ' || '''' ||
                            r_fact.factno || '''' || '
                     GROUP BY a.yyyymm,
                           a.detc_code,b.sku_nm,
                           a.rep_branch,e.entityname,
                           a.rep_seq_no,a.item_name,
                           a.group_id) '
                           ELSE
                            ' (select 
                           a.yyyymm,
                           b.' || p_type ||
                            ' as bu_code,d.ch_name,
                           a.rep_branch,e.entityname,
                           a.rep_seq_no,''<pre>''||a.item_name||''</pre>'' as item_name,
                           a.group_id,
                           to_char(SUM(coalesce(a.amt, 0)),''999G999G999G999D00'') as amt
                      from blm801t0 a, sku b, erp_detc_code d, blm_entity e
                     where a.rep_kind = ' || '''' ||
                            p_rep_kind || '''' || '
                       and a.detc_code = b.sku_no
                       and b.' || p_type ||
                            ' = d.detc_code
                       and a.rep_branch = e.rep_banch
                       and a.yyyy = e.yyyy
                       and a.yyyy = ' || chr(39) ||
                            p_yyyy || chr(39) || '
                       and a.factno = ' || '''' ||
                            r_fact.factno || '''' || '
                     GROUP BY a.yyyymm,
                           b.' || p_type ||
                            ',d.ch_name,
                           a.rep_branch,e.entityname,
                           a.rep_seq_no,a.item_name,
                           a.group_id) '
                       END;
            epm_report.p_pivot_row(p_table => l_table, p_keep_cols => 'yyyymm,bu_code,ch_name,rep_branch,entityname,rep_seq_no,item_name', p_pivot_col => 'group_id', p_pivot_val => 'amt', p_pivot_label_sql => ' select max(group_name) from blm801t0 ' ||
                                                         '  where rep_kind=' ||
                                                         chr(39) ||
                                                         p_rep_kind ||
                                                         chr(39) ||
                                                         '    and factno = ' ||
                                                         chr(39) ||
                                                         r_fact.factno ||
                                                         chr(39) ||
                                                         '    and yyyy = ' ||
                                                         chr(39) ||
                                                         p_yyyy ||
                                                         chr(39) ||
                                                         '    and group_id =:1', p_order_by => 'rep_branch,bu_code,rep_seq_no', p_sql => l_sql, p_labels => l_labels);
        
            htp.prn('<table class="' || p_table_class || '"><thead>');
        
            -- TH 
            htp.prn('<tr><th class="mOuter">' || r_fact.factname ||
                    '</th></tr>');
        
            l_labels := l_keep_header || rtrim(l_labels, ':');
            l_labels := '<tr><th>' || REPLACE(l_labels, ':', '</th><th>') ||
                        '</th></tr>';
            htp.prn(l_labels);
        
            -- TBODY
            htp.prn('</thead><tbody>');
            OPEN l_curosr FOR l_sql;
            LOOP
                EXIT WHEN l_curosr%NOTFOUND;
                FETCH l_curosr
                    INTO l_row;
                htp.prn(l_row);
                --
                l_value_cnt := l_value_cnt + 1;
            END LOOP;
            CLOSE l_curosr;
        
            htp.prn('</tbody></table>');
        END LOOP; -- c_fact 
    
        --
        IF l_value_cnt > 1 THEN
            p_print_downloadlink(p_request_in => p_request);
        END IF;
        --
        htp.prn('</body></html>');
        p_stop_print(p_request_in => p_request);
    
    END;
    --

    PROCEDURE p_rep_801_d(p_year        IN VARCHAR2,
                          p_detc_code   IN VARCHAR2,
                          p_rep_kind    IN VARCHAR2,
                          p_version     IN VARCHAR2,
                          p_table_class IN VARCHAR2 DEFAULT 'uReport',
                          p_request     IN VARCHAR2 DEFAULT 'GO',
                          p_filename    IN VARCHAR2 DEFAULT 'REPORT') IS
        l_str          CLOB;
        l_str2         CLOB;
        l_head2        VARCHAR2(40) := '<th>金额</th><th>比率</th>';
        l_keep_header  VARCHAR2(400);
        l_group_header VARCHAR2(400);
        l_keep_col_num NUMBER;
        l_value_cnt    NUMBER := 0;
    
        -- 透视列     
        CURSOR c_header IS
            SELECT a.group_id AS headno, a.group_name AS headname,
                   COUNT(1) over(ORDER BY 1) * 2 + l_keep_col_num AS cnt
              FROM blm801t0 a
             WHERE a.rep_kind = p_rep_kind
               AND a.detc_code LIKE p_detc_code || '%'
               AND a.yyyy = p_year
               AND a.version_id = p_version
             GROUP BY a.group_id, a.group_name
             ORDER BY a.group_id;
    
        -- 列标签   
        CURSOR c_keep_cols IS
            SELECT yyyy, version_id, rep_seq_no, item_name
              FROM blm801t0
             WHERE rep_kind = p_rep_kind
               AND detc_code LIKE p_detc_code || '%'
               AND yyyy = p_year
               AND version_id = p_version
             GROUP BY yyyy, version_id, rep_seq_no, item_name
             ORDER BY yyyy, version_id, rep_seq_no;
        -- 值
        CURSOR c_value(p_rep_seq_no IN VARCHAR2,
                       p_yyyy       IN VARCHAR2,
                       p_version    IN VARCHAR2) IS
            WITH t AS
             (SELECT group_id, SUM(a.amt) AS amt
                FROM blm801t0 a
               WHERE a.rep_kind = p_rep_kind
                 AND a.rep_seq_no = '0206'
                 AND a.yyyy = p_year
                 AND a.detc_code LIKE p_detc_code || '%'
                 AND a.version_id = p_version
               GROUP BY group_id
               ORDER BY group_id),
            m AS
             (SELECT group_id, SUM(b.amt) AS VALUE
                FROM blm801t0 b
               WHERE b.rep_kind = p_rep_kind
                 AND b.rep_seq_no = p_rep_seq_no
                 AND b.yyyy = p_year
                 AND b.version_id = p_version
                 AND b.detc_code LIKE p_detc_code || '%'
               GROUP BY group_id
               ORDER BY group_id)
            SELECT to_char(m.value, '999G999G999G999D00') AS VALUE,
                   CASE t.amt
                        WHEN 0 THEN
                         '0'
                        ELSE
                         to_char(m.value / t.amt * 100, '999G999D00') || '%'
                    END AS pct
              FROM m, t
             WHERE m.group_id = t.group_id;
    
    BEGIN
    
        -- meta and head
        p_print_meta(p_request_in => p_request, p_filename_in => p_filename);
        p_print_head(p_request_in => p_request);
    
        -- body
        htp.prn('<body>');
    
        p_return_col_grp(p_rep_kind => p_rep_kind, p_keep_col_num => l_keep_col_num, p_keep_header => l_keep_header, p_group_header => l_group_header, p_type => 'D');
    
        -- table Start
        htp.prn('<table class="' || p_table_class || '">');
    
        htp.prn('<thead>');
    
        FOR r_head IN c_header LOOP
            IF c_header%ROWCOUNT = 1 THEN
            
                /*htp.prn('<tr><th class="mOuter" colspan=' || r_head.cnt || '>' ||
                r_group.groupname || '</th></tr>');*/
                -- 列标签分组
                IF l_group_header IS NOT NULL THEN
                    htp.prn('<tr>' || l_group_header || '</tr>');
                END IF;
            
            END IF;
            l_str  := l_str || '<th colspan=2>' || r_head.headname ||
                      '</th>';
            l_str2 := l_str2 || l_head2;
        END LOOP;
    
        l_str := l_keep_header || l_str; -- header标签
    
        htp.prn(l_str);
        htp.prn('<tr>' || l_str2 || '</tr>');
        htp.prn('</thead>');
        l_str := NULL;
    
        -- thead End
        -- tbody Start
        htp.prn('<tbody>');
    
        FOR r_keep_col IN c_keep_cols LOOP
            l_str := '<tr><td>' || r_keep_col.yyyy || '</td>' || '<td>' ||
                     r_keep_col.version_id || '</td>' || '<td>' ||
                     r_keep_col.rep_seq_no || '</td>' || '<td>' ||
                     r_keep_col.item_name || '</td>';
            htp.prn(l_str);
            -- Keep Cols End 
        
            -- Values Start
            l_str := NULL;
            FOR r_value IN c_value(r_keep_col.rep_seq_no, r_keep_col.yyyy, r_keep_col.version_id) LOOP
                -- 透视字段
                l_str       := l_str || '<td align=right>' || r_value.value ||
                               '</td>' || '<td align=right>' || r_value.pct ||
                               '</td>';
                l_value_cnt := l_value_cnt + 1;
            END LOOP;
        
            htp.prn(l_str || '</tr>');
            l_str := NULL;
        
        END LOOP;
        htp.prn('</tbody>');
        htp.prn('</table>');
    
        --
        IF l_value_cnt > 1 THEN
            p_print_downloadlink(p_request_in => p_request);
        END IF;
    
        htp.prn('</body></html>');
    
        -- stop print
        p_stop_print(p_request_in => p_request);
    END p_rep_801_d;

    PROCEDURE refresh_dw100(p_yyyy IN VARCHAR2, p_version IN VARCHAR2) IS
    BEGIN
        DELETE FROM t_dw100
         WHERE fyyyy = p_yyyy
           AND fversion_id = p_version;
    
        INSERT INTO t_dw100
            (fyyyy, fversion_id, fyyyymm, fmark, fmark_plan, farea_no,
             farea_name, ffact_no, ffact_name, fclus_no, fclus_name,
             fclus_no2, fclus_name2, fsku_shapes, fsku_shapes_name, fqty,
             fstan_qty)
        
            WITH shape AS
             (SELECT sku_no,
                     CAST(wmsys.wm_concat(m.fno) AS VARCHAR2(255)) AS sku_shapes,
                     CAST(wmsys.wm_concat(m.fname) AS VARCHAR2(255)) AS sku_shape_name
                FROM blm012t0 n, blm014t0 m
               WHERE n.yyyy = m.yyyy
                 AND n.yyyy = p_yyyy
                 AND m.yyyy = p_yyyy
                 AND n.sku_shape = m.fno
                 AND m.ftype = 'PROD'
               GROUP BY sku_no)
            SELECT a.yyyy, a.version_id, a.yyyymm, a.mark,
                   coalesce(b.mark_plan, '-') AS mark_plan, e.area_no,
                   (SELECT f.branch_name
                       FROM erp_pub112t0 f
                      WHERE f.branch_no = e.area_no) AS area_name, e.factno,
                   (SELECT f.branch_name
                       FROM erp_pub112t0 f
                      WHERE f.branch_no = e.factno) AS fact_name, b.clus_no,
                   b.clus_nm,
                   coalesce((SELECT g.fattr01
                               FROM t_item g
                              WHERE g.ftype = 7261
                                AND g.fno = b.clus_no), b.clus_no) AS clus_no2,
                   coalesce((SELECT g.fattr02
                               FROM t_item g
                              WHERE g.ftype = 7261
                                AND g.fno = b.clus_no), b.clus_nm) AS clus_nm2,
                   coalesce(c.sku_shapes, '-') AS sku_shapes,
                   coalesce(c.sku_shape_name, '-') AS sku_shape_name,
                   SUM(a.amt) AS qty,
                   SUM(a.amt * coalesce(b.stan_per, 1)) stan_qty
              FROM blm100t0 a
              JOIN mv_sku b
                ON a.detc_code = b.sku_no
              LEFT JOIN shape c
                ON a.detc_code = c.sku_no
              JOIN (SELECT a.region_code, a.factno, b.area_no, a.bu_code,
                           a.yyyy
                      FROM region_factno a,
                           (SELECT factno, area_no, bu_code, yyyy
                               FROM region_factno
                              WHERE region_code = 'ALL'
                                AND yyyy = p_yyyy
                                AND version_id = p_version
                              GROUP BY factno, area_no, bu_code, yyyy) b
                     WHERE a.factno = b.factno
                       AND a.bu_code = b.bu_code
                       AND a.yyyy = b.yyyy
                       AND a.yyyy = p_yyyy
                       AND a.version_id = p_version
                       AND a.region_code <> 'ALL') e
                ON a.region_no = e.region_code
             WHERE a.mark_keyin = '2'
               AND a.yyyy = p_yyyy
               AND a.version_id = p_version
                  --AND b.mark_plan IS NOT NULL
               AND a.region_no <> 'ALL'
               AND b.clus_no = e.bu_code
             GROUP BY a.yyyy, a.version_id, a.yyyymm, a.mark, b.mark_plan,
                      e.area_no, e.factno, b.clus_no, b.clus_nm,
                      c.sku_shapes, c.sku_shape_name
            UNION ALL
            
            SELECT a.yyyy, a.version_id, a.yyyymm, a.mark,
                   coalesce(b.mark_plan, '-') AS mark_plan, e.area_no,
                   (SELECT f.branch_name
                       FROM erp_pub112t0 f
                      WHERE f.branch_no = e.area_no) AS area_name, e.factno,
                   (SELECT f.branch_name
                       FROM erp_pub112t0 f
                      WHERE f.branch_no = e.factno) AS fact_name, b.clus_no,
                   b.clus_nm,
                   coalesce((SELECT g.fattr01
                               FROM t_item g
                              WHERE g.ftype = 7261
                                AND g.fno = b.clus_no), b.clus_no) AS clus_no2,
                   coalesce((SELECT g.fattr02
                               FROM t_item g
                              WHERE g.ftype = 7261
                                AND g.fno = b.clus_no), b.clus_nm) AS clus_nm2,
                   coalesce(c.sku_shapes, '-') AS sku_shapes,
                   coalesce(c.sku_shape_name, '-') AS sku_shape_name,
                   SUM(a.amt) AS qty,
                   SUM(a.amt * coalesce(b.stan_per, 1)) AS stan_qty
              FROM blm100t0 a
              JOIN mv_sku b
                ON a.detc_code = b.sku_no
              LEFT JOIN shape c
                ON a.detc_code = c.sku_no
              JOIN blm_entity f
                ON f.entitycode = a.branch_no
              JOIN region_factno e
                ON f.factno = e.factno
             WHERE a.mark_keyin = '2'
               AND a.yyyy = p_yyyy
               AND a.version_id = p_version
               AND e.version_id = p_version
               AND e.yyyy = p_yyyy
                  -- AND b.mark_plan IS NOT NULL
               AND a.region_no = 'ALL'
               AND e.region_code = 'ALL'
               AND b.clus_no = e.bu_code
             GROUP BY a.yyyy, a.version_id, a.yyyymm, a.mark, b.mark_plan,
                      e.area_no, e.factno, b.clus_no, b.clus_nm,
                      c.sku_shapes, c.sku_shape_name;
    EXCEPTION
        WHEN OTHERS THEN
            raise_application_error(-20001, 'refresh_dw100:' || SQLERRM);
    END;

    --
    PROCEDURE refresh_dw200(p_yyyy IN VARCHAR2, p_version IN VARCHAR2) IS
    BEGIN
        DELETE FROM t_dw200
         WHERE fyyyy = p_yyyy
           AND fversion_id = p_version;
    
        INSERT INTO t_dw200
            (fyyyy, fversion_id, fyyyymm, fmark_apportion, ffact_no,
             ffact_name, fclus_no, fclus_name, fclus_no2, fclus_name2,
             facs_code, facs_name, fsub_code, fsub_name, fsta_place,
             fsta_name, famt)
        
            SELECT a.yyyy, a.version_id, a.yyyymm, a.mark_apportion,
                   a.factno,
                   (SELECT f.branch_name
                       FROM erp_pub112t0 f
                      WHERE f.branch_no = a.factno) AS fact_name,
                   
                   b.clus_no, b.clus_nm,
                   coalesce((SELECT g.fattr01
                               FROM t_item g
                              WHERE g.ftype = 7261
                                AND g.fno = b.clus_no), b.clus_no) AS clus_no2,
                   coalesce((SELECT g.fattr02
                               FROM t_item g
                              WHERE g.ftype = 7261
                                AND g.fno = b.clus_no), b.clus_nm) AS clus_nm2,
                   a.acs_code,
                   (SELECT g.ch_name
                       FROM erp_acs_code g
                      WHERE g.acs_code = a.acs_code) AS acs_name, a.sub_code,
                   (SELECT g.ch_name
                       FROM erp_sub_code g
                      WHERE g.sub_code = a.sub_code) AS sub_name,
                   a.sta_place,
                   (SELECT g.entityname
                       FROM blm_entity g
                      WHERE g.entitycode = a.sta_place
                        AND g.yyyy = p_yyyy) AS fsta_name, SUM(a.amt) AS amt
              FROM blm200t0 a
              JOIN mv_sku b
                ON a.detc_code = b.sku_no
             WHERE a.mark_keyin = '2'
               AND a.yyyy = p_yyyy
               AND a.version_id = p_version
             GROUP BY a.yyyy, a.version_id, a.yyyymm, a.mark_apportion,
                      a.factno, b.clus_no, b.clus_nm, a.acs_code, a.sub_code,
                      a.sta_place;
    
    EXCEPTION
        WHEN OTHERS THEN
            raise_application_error(-20001, 'refresh_dw200:' || SQLERRM);
    END;
    --
    PROCEDURE refresh_dw600(p_yyyy IN VARCHAR2, p_version IN VARCHAR2) IS
    BEGIN
        DELETE FROM t_dw600
         WHERE fyyyy = p_yyyy
           AND fversion_id = p_version;
    
        INSERT INTO t_dw600
            (fyyyy, fversion_id, fyyyymm, farea_no, farea_name, ffact_no,
             ffact_name, frelfact_no, frelfact_name, fclus_no, fclus_name,
             fsku_shapes, fsku_shapes_name, fqty, fstan_qty, fmark)
        
            WITH shape AS
             (SELECT m.fno, m.fname
                FROM blm014t0 m
               WHERE m.yyyy = p_yyyy
                 AND m.ftype = 'PROD'),
            tmp AS
             ( -- 本厂自供
              SELECT a.yyyy, a.version_id, a.yyyymm, a.area_no2, a.factno,
                      NULL AS frelfact_no, b.clus_no, b.clus_nm, p.fno, p.fname,
                      SUM(a.qty / coalesce(b.stan_per, 1)) AS qty,
                      SUM(a.qty) AS stan_qty, 3 AS mark
                FROM blm600t1 a, mv_sku b, blm013t0 c, shape p
               WHERE a.mark = '1'
                 AND a.oem_mark IN ('1', '21', '22')
                 AND a.dept_no = c.dept_no
                 AND c.sku_shape = p.fno
                 AND a.yyyy = p_yyyy
                 AND a.version_id = p_version
                 AND a.sku_no = b.sku_no
                    -- AND b.mark_plan IS NOT NULL
                    -- AND a.area_no = a.area_no2 -- 区域内
                 AND coalesce(rel_factno, 'ALL') = 'ALL'
               GROUP BY a.yyyy, a.version_id, a.yyyymm, a.area_no2, a.factno,
                         b.clus_no, b.clus_nm, p.fno, p.fname
              UNION ALL
              
              --被支援
              SELECT a.yyyy, a.version_id, a.yyyymm, a.area_no,
                     a.rel_factno AS factno, a.factno AS frelfact_no,
                     b.clus_no, b.clus_nm, p.fno, p.fname,
                     SUM(a.qty / coalesce(b.stan_per, 1)) AS qty,
                     SUM(a.qty) AS stan_qty, 4 AS mark
                FROM blm600t1 a, mv_sku b, blm013t0 c, shape p
               WHERE a.mark = '1'
                 AND a.oem_mark IN ('1', '21', '22')
                    -- AND b.mark_plan IS NOT NULL
                 AND a.dept_no = c.dept_no
                 AND c.sku_shape = p.fno
                 AND a.yyyy = p_yyyy
                 AND a.version_id = p_version
                 AND a.sku_no = b.sku_no
                 AND a.rel_factno <> 'ALL'
               GROUP BY a.yyyy, a.version_id, a.yyyymm, a.area_no,
                        a.rel_factno, a.factno, b.clus_no, b.clus_nm, p.fno,
                        p.fname
              UNION ALL
              
              --支援
              SELECT a.yyyy, a.version_id, a.yyyymm, a.area_no2, a.factno,
                     a.rel_factno AS frelfact_no, b.clus_no, b.clus_nm, p.fno,
                     p.fname, SUM(a.qty / coalesce(b.stan_per, 1)) AS qty,
                     SUM(a.qty) AS stan_qty, 5 AS mark
                FROM blm600t1 a, mv_sku b, blm013t0 c, shape p
               WHERE a.mark = '1'
                 AND a.oem_mark IN ('1', '21', '22')
                 AND a.dept_no = c.dept_no
                 AND c.sku_shape = p.fno
                 AND a.yyyy = p_yyyy
                 AND a.version_id = p_version
                 AND a.sku_no = b.sku_no
                    -- AND b.mark_plan IS NOT NULL
                 AND a.rel_factno <> 'ALL'
               GROUP BY a.yyyy, a.version_id, a.yyyymm, a.area_no2, a.factno,
                        a.rel_factno, b.clus_no, b.clus_nm, p.fno, p.fname)
            
            SELECT t.yyyy, t.version_id, t.yyyymm, t.area_no2,
                   (SELECT f.branch_name
                       FROM erp_pub112t0 f
                      WHERE f.branch_no = t.area_no2) AS area_name, t.factno,
                   (SELECT f.branch_name
                       FROM erp_pub112t0 f
                      WHERE f.branch_no = t.factno) AS fact_name,
                   t.frelfact_no,
                   (SELECT f.branch_name
                       FROM erp_pub112t0 f
                      WHERE f.branch_no = t.frelfact_no) AS relfact_name,
                   t.clus_no, t.clus_nm, t.fno AS sku_shape,
                   t.fname AS sku_shape_name, t.qty, t.stan_qty, t.mark
              FROM tmp t;
    
        -- 生产量 ：自供 + 支援友厂
        INSERT INTO t_dw600
            (fyyyy, fversion_id, fyyyymm, farea_no, farea_name, ffact_no,
             ffact_name, fclus_no, fclus_name, fsku_shapes, fsku_shapes_name,
             fmark, fqty, fstan_qty)
            SELECT fyyyy, fversion_id, fyyyymm, farea_no, farea_name,
                   ffact_no, ffact_name, fclus_no, fclus_name, fsku_shapes,
                   fsku_shapes_name, '2' AS fmark, SUM(fqty) AS fqty,
                   SUM(fstan_qty) AS fstan_qty
              FROM t_dw600
             WHERE fmark IN ('3', '5')
             GROUP BY fyyyy, fversion_id, fyyyymm, farea_no, farea_name,
                      ffact_no, ffact_name, fclus_no, fclus_name,
                      fsku_shapes, fsku_shapes_name;
    
    END;
    PROCEDURE show_report_aps_1(p_yyyy        IN VARCHAR2,
                                p_version     IN VARCHAR2,
                                p_area        IN VARCHAR2,
                                p_factno      IN VARCHAR2,
                                p_clus        IN VARCHAR2,
                                p_request     IN VARCHAR2 DEFAULT 'GO',
                                p_filename    IN VARCHAR2 DEFAULT 'Report',
                                p_table_class IN VARCHAR2 DEFAULT 'uReport') IS

        CURSOR c_v IS
            SELECT *
              FROM (SELECT a.v1 AS yyyy, a.v2 AS version,
                            substr(a.v3, 5, 2) AS mm, /*a.v4 AS area_no,
                            a.v11 AS area_name,*/ a.v4 AS factno, a.v12 AS fact_name,
                            a.v6 AS sku_shape, a.v13 AS sku_shape_name,
                            a.v7 AS val,
                            CASE
                                WHEN a.v9 = 'H' AND a.n4 = 0 THEN
                                 to_char(a.n3)
                                ELSE
                                 a.v14
                            END AS item, a.v9 AS seq
                       FROM gt_temp a
                      WHERE a.main_code = 'VALUE'
                      ORDER BY a.v9, a.v6 NULLS LAST) pivot(MIN(val) FOR mm IN('01' AS "一月", '02' AS "二月", '03' AS "三月", '04' AS "四月", '05' AS "五月", '06' AS "六月", '07' AS "七月", '08' AS "八月", '09' AS "九月", '10' AS "十月", '11' AS
                                                                                "十一月", '12' AS
                                                                                "十二月"))
             ORDER BY seq;

        b_hasrow BOOLEAN := FALSE;

    BEGIN

        -- 清空临时表
        clear_gt_temp(p_main_codes => 'VALUE');

        -- 预估量
        INSERT INTO gt_temp
            (main_code, v1, v2, v3, /*v4, v11, */v5, v12, v6, v13, n2, v7, v14, v9,
             n1, n4)
        
            SELECT 'VALUE', a.fyyyy, a.fversion_id, a.fyyyymm, /*a.farea_no,
                   a.farea_name,*/ a.ffact_no, a.ffact_name, a.fsku_shapes,
                   a.fsku_shapes_name, SUM(a.fqty) AS qty_n,
                   to_char(SUM(a.fqty), '999G999G999G999') AS qty_v,
                   CASE
                       WHEN GROUPING(a.fsku_shapes) = 1 THEN
                        '<b> 预估量 合计</b>'
                       ELSE
                        '预估量'
                   END AS item, '0' AS mark, -1 AS fadd,
                   GROUPING(a.fsku_shapes) AS n4
              FROM t_dw100 a
             WHERE /*a.farea_no = p_area
               AND */a.fyyyy = p_yyyy
               AND a.fversion_id = p_version
               AND a.ffact_no = p_factno 
               AND a.fclus_no = p_clus 
               AND a.fmark = '7'
             GROUP BY GROUPING SETS((a.fyyyy, a.fversion_id, a.fyyyymm, /*a.farea_no, a.farea_name,*/ a.ffact_no, a.ffact_name),(a.fyyyy, a.fversion_id, a.fyyyymm, /*a.farea_no, a.farea_name,*/ a.ffact_no, a.ffact_name, a.fsku_shapes, a.fsku_shapes_name));

        INSERT INTO gt_temp
            (main_code, v1, v2, v3, /*v4, v11, */v5, v12, v6, v13, n2, v7, v14, v9,
             n1, n4)
        
            SELECT 'VALUE', a.fyyyy, a.fversion_id, a.fyyyymm, /*a.farea_no,
                   a.farea_name,*/ a.ffact_no, a.ffact_name, a.fsku_shapes,
                   a.fsku_shapes_name, SUM(a.fqty) AS qty_n,
                   to_char(SUM(a.fqty), '999G999G999') AS qty_v,
                   CASE
                       WHEN GROUPING(a.fsku_shapes) = 1 THEN
                        '<b>' ||
                        decode(a.fmark, '2', '生产量(实际箱)', '3', '子公司自供', '4', '被支援', '5', '支援友厂') ||
                        ' 合计</b>'
                       ELSE
                        decode(a.fmark, '2', '生产量(实际箱)', '3', '子公司自供', '4', max(a.frelfact_name) ||
                                '支援本厂', '5', '支援' || max(a.frelfact_name))
                   END AS item, to_char(fmark) AS fmark,
                   decode(a.fmark, '2', 0, '3', 1, '4', 1, '5', -1) AS fadd,
                   GROUPING(a.fsku_shapes) AS n4
              FROM t_dw600 a
             WHERE /*a.farea_no = p_area
               AND */a.fyyyy = p_yyyy
               AND a.fversion_id = p_version
               AND a.ffact_no = p_factno 
               AND a.fclus_no = p_clus 
               AND a.fmark IN (2, 3, 4, 5)
             GROUP BY GROUPING SETS((a.fyyyy, a.fversion_id, a.fyyyymm, /*a.farea_no, a.farea_name, */a.ffact_no, a.ffact_name, a.fmark),(a.fyyyy, a.fversion_id, a.fyyyymm, /*a.farea_no, a.farea_name, */a.ffact_no, a.ffact_name, a.frelfact_name, a.fsku_shapes, a.fsku_shapes_name, a.fmark));

        -- 生产量标准箱
        INSERT INTO gt_temp
            (main_code, v1, v2, v3, /*v4, v11,*/ v5, v12, v6, v13, n2, v7, v14, v9,
             n4)
        
            SELECT 'VALUE', a.fyyyy, a.fversion_id, a.fyyyymm, /*a.farea_no,
                   a.farea_name, */a.ffact_no, a.ffact_name, a.fsku_shapes,
                   a.fsku_shapes_name, SUM(a.fstan_qty) AS stan_qty_n,
                   to_char(SUM(a.fstan_qty), '999G999G999') AS stan_qty_v,
                   CASE
                       WHEN GROUPING(a.fsku_shapes) = 1 THEN
                        '<b> 生产量(标准箱) 合计</b>'
                       ELSE
                        '生产量(标准箱)'
                   END AS item, to_char(fmark) || 'A' AS fmark,
                   GROUPING(a.fsku_shapes) AS n4
              FROM t_dw600 a
             WHERE /*a.farea_no = p_area
               AND */a.fyyyy = p_yyyy
               AND a.fversion_id = p_version
               AND a.ffact_no = p_factno 
               AND a.fclus_no = p_clus 
               AND a.fmark = '2'
             GROUP BY GROUPING SETS((a.fyyyy, a.fversion_id, a.fyyyymm, /*a.farea_no, a.farea_name,*/ a.ffact_no, a.ffact_name, a.frelfact_name, a.fmark),(a.fyyyy, a.fversion_id, a.fyyyymm, /*a.farea_no, a.farea_name,*/ a.ffact_no, a.ffact_name, a.frelfact_name, a.fsku_shapes, a.fsku_shapes_name, a.fmark));

        -- 期末库存
        INSERT INTO gt_temp
            (main_code, v1, v2, v3,/* v4, v11, */v5, v12, v6, v13, n2, v7, v14, v9,
             n4)
        
            SELECT 'VALUE', a.v1 AS fyyyy, a.v2 AS fversion_id, a.v3 AS fyyyymm,
                   /*a.v4 AS farea_no, a.v11 AS farea_name,*/ a.v5 AS ffact_no,
                   a.v12 AS ffact_name, a.v6 AS fsku_shapes,
                   a.v13 AS fsku_shapes_name,
                   SUM(SUM(a.n2 * a.n1)) over(PARTITION BY a.v1, a.v2, /*a.v4, a.v11,*/ a.v5, a.v12, a.v6, a.v13 ORDER BY a.v3) AS qty_n,
                   to_char(SUM(SUM(a.n2 * a.n1)) over(PARTITION BY a.v1, a.v2, /*a.v4, a.v11,*/ a.v5, a.v12, a.v6, a.v13
                                  ORDER BY a.v3), '999G999G999G999D') AS qty,
                   NULL AS item, 'H' AS fmark, 0
              FROM gt_temp a
             WHERE a.main_code = 'VALUE'
               AND a.v9 IN ('0', '3', '4')
               AND a.n4 = 0 /* 合计项在加上期初后重新计算*/
             GROUP BY a.v1, a.v2, a.v3, /*a.v4, a.v11, */a.v5, a.v12, a.v6, a.v13;

        -- 加上期初
        DECLARE
            TYPE boy IS RECORD(
                yyyy      VARCHAR2(4),
                sku_shape VARCHAR2(255),
                qty       NUMBER);
            TYPE type_boy_table IS TABLE OF boy INDEX BY BINARY_INTEGER;
            t_boy type_boy_table;
        BEGIN
        
            WITH b AS
             (SELECT b.sku_no,
                     CAST(wmsys.wm_concat(b.sku_shape) AS VARCHAR2(100)) AS sku_shape
                FROM blm012t0 b
               WHERE b.yyyy = p_yyyy
               GROUP BY b.sku_no)
            SELECT p_yyyy, b.sku_shape, SUM(a.qty) BULK COLLECT
              INTO t_boy
              FROM blm500t0 a
              JOIN b
                ON a.prod_no = b.sku_no
             WHERE a.yyyymm = p_yyyy || '01'
               AND a.factno = p_factno 
               AND a.mark = '1'
               AND a.version_id = p_version
             GROUP BY b.sku_shape;
        
            FORALL i IN 1 .. t_boy.count
                UPDATE gt_temp a
                   SET v7 = to_char(n2 + t_boy(i).qty, '999G999G999G999'),
                       n2 = n2 + t_boy(i).qty,
                       n3 = t_boy(i).qty
                 WHERE a.v6 = t_boy(i).sku_shape
                   AND a.v1 = t_boy(i).yyyy
                   AND a.main_code = 'VALUE'
                   AND a.v9 = 'H';
        END;

        -- 期末库存合计
        INSERT INTO gt_temp
            (main_code, v1, v2, v3, /*v4, v11,*/ v5, v12, v6, v13, n2, v7, v14, v9)
            SELECT 'VALUE', a.v1 AS fyyyy, a.v2 AS fversion_id, a.v3 AS fyyyymm,
                   /*a.v4 AS farea_no, a.v11 AS farea_name,*/ a.v5 AS ffact_no,
                   a.v12 AS ffact_name, NULL AS fsku_shapes,
                   NULL AS fsku_shapes_name, SUM(to_number(n2)) AS qty_n,
                   to_char(SUM(to_number(n2)), '999G999G999G999') AS qty,
                   '<b> 期末库存(实际箱) 合计</b>' AS item, 'H' AS fmark
              FROM gt_temp a
             WHERE a.main_code = 'VALUE'
               AND a.v9 = 'H'
             GROUP BY a.v1, a.v2, a.v3, /*a.v4, a.v11,*/ a.v5, a.v12;

        -- 产能、剩余产能、产能利用率
        INSERT INTO gt_temp
            (main_code, v1, v2, v3, /*v4, v11,*/ v5, v12, v6, v13, v7, v14, v9)
        
            WITH shape AS
             (SELECT m.fno, m.fname
                FROM blm014t0 m
               WHERE m.yyyy = p_yyyy
                 AND m.ftype = 'PROD'),
            c AS
             (SELECT a.yyyy, a.yyyymm, a.area_no area2_no, /*供货区域*/ a.factno
                      /*供货子公司*/, a.dept_no, p.fno, p.fname, SUM(qty) AS qty
                FROM blm620t0 a, blm013t0 b, shape p
               WHERE a.dept_no = b.dept_no
                 AND b.sku_shape = p.fno
                 AND b.yyyy = a.yyyy
                 AND coalesce(qty, 0) > 0
                 AND a.yyyy = p_yyyy
                 AND b.yyyy = p_yyyy
                 AND a.version_id = p_version
                 /*AND a.area_no = p_area*/
                 AND b.clus_no = p_clus 
                 AND a.factno = p_factno 
               GROUP BY a.yyyy, a.yyyymm, a.area_no, a.factno, a.dept_no, p.fno,
                        p.fname),
            a AS
             (SELECT a.yyyy, a.version_id, a.yyyymm, a.dept_no, SUM(qty) AS qty
                      /*标准箱*/, SUM(qty / b.stan_per) qty_act /*实际箱*/
                FROM blm600t1 a, mv_sku b
               WHERE a.sku_no = b.sku_no
                 AND a.mark = '1'
                 AND a.oem_mark IN ('1', '21', '22')
                 AND b.mark_plan IS NOT NULL
                 AND a.yyyy = p_yyyy
                 AND a.version_id = p_version
                 AND b.clus_no = p_clus 
               GROUP BY a.yyyy, a.version_id, a.yyyymm, a.dept_no
              HAVING SUM(a.qty) > 0
              
              ),
            b AS
             (SELECT a.yyyy, a.version_id, a.yyyymm, a.dept_no, c.area2_no,
                     (SELECT f.branch_name
                         FROM erp_pub112t0 f
                        WHERE f.branch_no = c.area2_no) AS area_name, c.factno,
                     (SELECT f.branch_name
                         FROM erp_pub112t0 f
                        WHERE f.branch_no = c.factno) AS fact_name, c.fno,
                     c.fname, SUM(a.qty) AS m, SUM(c.qty) AS d, SUM(qty_act) g,
                     SUM(SUM(a.qty)) over(PARTITION BY a.yyyy, a.yyyymm, a.dept_no ORDER BY 1) AS m_sum
                FROM a, c
               WHERE c.yyyymm = a.yyyymm
                 AND a.dept_no = c.dept_no
                 AND a.yyyy = c.yyyy
               GROUP BY a.yyyy, a.version_id, a.yyyymm, a.dept_no, c.area2_no,
                        c.factno, c.fno, c.fname)
            -- 标准产能
            
            SELECT 'VALUE', yyyy, version_id, yyyymm, /*area2_no, area_name,*/
                   factno, fact_name, fno, fname,
                   to_char(SUM(d), '999G999G999') AS cap,
                   CASE
                       WHEN GROUPING(fno) = 1 THEN
                        '<b>合计</b>'
                       ELSE
                        '标准产能'
                   END AS item, 'E' AS fmark
              FROM b
             GROUP BY GROUPING SETS((yyyy, version_id, yyyymm, /*area2_no, area_name,*/ factno, fact_name),(yyyy, version_id, yyyymm, /*area2_no, area_name,*/ factno, fact_name, fno, fname))
            
            UNION ALL  --剩余产能
            SELECT 'VALUE', yyyy, version_id, yyyymm, /*area2_no, area_name,*/
                   factno, fact_name, fno, fname,
                   to_char(SUM(d - m_sum), '999G999G999') AS cap_plus,
                   CASE
                       WHEN GROUPING(fno) = 1 THEN
                        '<b>合计</b>'
                       ELSE
                        '剩余产能'
                   END AS item, 'F' AS fmark

              FROM b
             GROUP BY GROUPING SETS((yyyy, version_id, yyyymm, /*area2_no, area_name,*/ factno, fact_name),(yyyy, version_id, yyyymm, /*area2_no, area_name,*/ factno, fact_name, fno, fname))
        UNION ALL -- 产能利用率
            SELECT 'VALUE', yyyy, version_id, yyyymm, /*area2_no, area_name,*/
                   factno, fact_name, fno, fname,
                   regexp_replace(to_char(round(AVG(CASE
                                                        WHEN d = 0 THEN
                                                         0
                                                        ELSE
                                                         m_sum / d * 100
                                                    END), 2)) || '%', '^0%$', NULL) AS pct,
                   CASE
                       WHEN GROUPING(fno) = 1 THEN
                        '<b>平均</b>'
                       ELSE
                        '产能利用率'
                   END AS item, 'G' AS seq
              FROM b
             GROUP BY GROUPING SETS((yyyy, version_id, yyyymm, /*area2_no, area_name,*/ factno, fact_name),(yyyy, version_id, yyyymm, /*area2_no, area_name,*/ factno, fact_name, fno, fname));

        -- 输出meta 和 head 
        p_print_meta(p_request_in => p_request, p_filename_in => p_filename);
        p_print_head(p_request_in => p_request);

        htp.prn('<table class="' || p_table_class || '">');

        htp.prn('<thead>');

        htp.prn('<th>年度</th><th>版本</th><th>子公司</th><th>包材</th><th>项目</th><th>一月</th>
            <th>二月</th><th>三月</th><th>四月</th><th>五月</th><th>六月</th><th>七月</th><th>八月</th>
            <th>九月</th><th>十月</th><th>十一月</th><th>十二月</th>');

        htp.prn('</thead>');
        htp.prn('<tbody>');

        -- 输出报表内容
        FOR r IN c_v LOOP
            EXIT WHEN c_v%NOTFOUND;
        
            b_hasrow := TRUE;
        
            htp.prn('<tr>' || wrap_cell(r.yyyy) || wrap_cell(r.version) ||
                    /*wrap_cell(r.area_name) || */wrap_cell(r.fact_name) ||
                    wrap_cell(r.sku_shape_name) || wrap_cell(r.item) ||
                    wrap_cell_num(r."一月") || wrap_cell_num(r."二月") ||
                    wrap_cell_num(r."三月") || wrap_cell_num(r."四月") ||
                    wrap_cell_num(r."五月") || wrap_cell_num(r."六月") ||
                    wrap_cell_num(r."七月") || wrap_cell_num(r."八月") ||
                    wrap_cell_num(r."九月") || wrap_cell_num(r."十月") ||
                    wrap_cell_num(r."十一月") || wrap_cell_num(r."十二月") ||
                    '</tr>');
        END LOOP;
        htp.prn('</tbody>');
        htp.prn('</table>');

        -- 如果没有记录，就不输出下载链接
        IF b_hasrow THEN
            p_print_downloadlink(p_request_in => p_request);
        END IF;
        -- 
        htp.prn('</html>');
        p_stop_print(p_request_in => p_request);
    END;

    --
    PROCEDURE show_report_aps_2(p_yyyymm      IN VARCHAR2,
                                p_sum_item    IN VARCHAR2,
                                p_aps         IN epm_aps.type_aps,
                                p_request     IN VARCHAR2 DEFAULT 'GO',
                                p_filename    IN VARCHAR2 DEFAULT 'Report.xls',
                                p_table_class IN VARCHAR2 DEFAULT 'uReport') IS

        CURSOR c_v IS
            SELECT 'VAL',
                   
                   apex_item.checkbox2(p_idx => 1, p_value => a.qty || ':' ||
                                                    a.src_seq, p_attributes => ' onclick="setQty(''ROW'',this)" checked="checked" name="f01" id="f01_' ||
                                                         lpad(row_number()
                                                              over(ORDER BY 1), 4, '0') || '"') AS cbox,
                   a.yyyymm, a.region_no,
                   (SELECT b.province || ' - ' || b.regi_nm
                       FROM erp_region_code b
                      WHERE a.region_no = 'R' || b.regi_id) AS regi_nm,
                   a.sku_no,
                   (SELECT b.sku_nm FROM mv_sku b WHERE a.sku_no = b.sku_no) AS sku_nm,
                   
                   a.factno,
                   (SELECT b.branch_name
                       FROM erp_pub112t0 b
                      WHERE a.factno = b.branch_no) AS fact_name,
                   a.sku_shapes,
                   (SELECT CAST(wmsys.wm_concat(b.fname) AS VARCHAR2(255))
                       FROM blm014t0 b
                      WHERE instr(',' || a.sku_shapes || ',', ',' || b.fno || ',') > 0) AS sku_shape_nm,
                   a.area_no,
                   (SELECT b.branch_name
                       FROM erp_pub112t0 b
                      WHERE a.area_no = b.branch_no) AS area_name, a.clus_no,
                   (SELECT b.product_nm
                       FROM blm_product b
                      WHERE b.bud_product = a.clus_no) AS clus_name, a.qty,
                   a.src_seq
              FROM blm600t2 a
             WHERE a.yyyymm = p_yyyymm
               AND a.clus_no = p_aps.clus_no --事业群
               AND a.area_no = p_aps.area_no --区域
               AND a.factno = p_aps.factno --子公司
               AND a.sku_shapes LIKE p_aps.sku_shapes || '%' --包装
               AND ( instr(':' || p_aps.skus || ':', ':' || a.sku_no || ':') > 0 OR p_aps.skus IS NULL)-- sku
                  
               AND (instr(':' || p_aps.regions || ':', ':' || a.region_no || ':') > 0 OR
                   p_aps.regions IS NULL) -- 地级市为空认为是全部
               AND EXISTS (SELECT 1
                      FROM erp_region_code b
                     WHERE 'R' || b.regi_id = a.region_no
                       AND b.province_id LIKE p_aps.prov || '%' -- 行政省允许全选
                    )
                  
               AND a.qty <> 0;

        b_hasrow  BOOLEAN := FALSE;
        n_sum_qty NUMBER := 0;
        c_skus    CLOB;
    BEGIN

        -- 输出meta 和 head 
        p_print_meta(p_request_in => p_request, p_filename_in => p_filename);
        p_print_head(p_request_in => p_request);

        -- 输出统计

        htp.prn('<div class="head" ><span class="label">标准箱合计</span><span class=" big" id="' ||
                p_sum_item || '">0</span></div>');

        IF p_aps.show_detail = 'Y' THEN
        
            htp.prn('<table class="' || p_table_class || '">');
            htp.prn('<thead>');
        
            htp.prn('<th><INPUT id="check_box_all" onclick="setQty(''ALL'',this)" type="checkbox" checked="checked" value=""></th>');
            htp.prn('<th>区域</th><th>地级市</th><th>子公司</th><th>事业群</th><th>SKU编号</th>
                    <th>SKU名称</th><th>包装</th><th>数量</th>');
        
            htp.prn('</thead>');
            htp.prn('<tbody>');
        
            -- 输出报表内容
            FOR r IN c_v LOOP
                EXIT WHEN c_v%NOTFOUND;
            
                b_hasrow  := TRUE;
                n_sum_qty := r.qty + n_sum_qty;
            
                htp.prn('<tr>' || wrap_cell(r.cbox, 'align="center"') ||
                        wrap_cell(r.area_name) || wrap_cell(r.regi_nm) ||
                        wrap_cell(r.fact_name) || wrap_cell(r.clus_name) ||
                        wrap_cell(r.sku_no) || wrap_cell(r.sku_nm) ||
                        wrap_cell(r.sku_shape_nm) || wrap_cell_num(r.qty) ||
                        '</tr>');
            END LOOP;
            htp.prn('</tbody>');
            htp.prn('</table>');
        
            -- 如果没有记录，就不输出下载链接
            IF b_hasrow THEN
                p_print_downloadlink(p_request_in => p_request);
            END IF;
        
        ELSE

            SELECT SUM(qty), wmsys.wm_concat(sku_no)
              INTO n_sum_qty, c_skus
              FROM (SELECT SUM(a.qty) AS qty, a.sku_no
                       FROM blm600t2 a
                      WHERE a.yyyymm = p_yyyymm
                        AND a.clus_no = p_aps.clus_no --事业群
                        AND a.area_no = p_aps.area_no --区域
                        AND a.factno = p_aps.factno --子公司
                        AND a.sku_shapes LIKE p_aps.sku_shapes || '%' --包装
                        AND (instr(':' || p_aps.skus || ':', ':' || a.sku_no || ':') > 0 OR
                            p_aps.skus IS NULL) -- sku     
                        AND (instr(':' || p_aps.regions || ':', ':' ||
                                    a.region_no || ':') > 0 OR
                            p_aps.regions IS NULL) -- 地级市为空认为是全部
                        AND EXISTS
                      (SELECT 1
                               FROM erp_region_code b
                              WHERE 'R' || b.regi_id = a.region_no
                                AND b.province_id LIKE p_aps.prov || '%' -- 行政省允许全选
                             )
                        AND a.qty <> 0
                      GROUP BY a.sku_no);
             
             apex_util.set_session_state(p_name=>'P'||wwv_flow.g_flow_step_id||'_SKU',p_value=>c_skus);
         
        END IF;

        -- 合计项
        htp.prn('
                <script>$("#check_box_all").val(' || n_sum_qty ||
                ');$("#' || p_sum_item || '").text(' || coalesce(n_sum_qty, 0) ||
                ');$("#' || p_sum_item || '_HIDDEN").val(' ||
                coalesce(n_sum_qty, 0) || ');'||'</script>');
        --
        htp.prn('</html>');
        p_stop_print(p_request_in => p_request);
    END;
    --
    PROCEDURE show_report_aps_3(p_yyyy        IN VARCHAR2,
                                p_version     IN VARCHAR2,
                                p_yyyymm      IN VARCHAR2,
                                p_area        IN VARCHAR2,
                                p_fact        IN VARCHAR2 DEFAULT NULL,
                                p_clus        IN VARCHAR2 DEFAULT NULL,
                                p_request     IN VARCHAR2 DEFAULT 'GO',
                                p_filename    IN VARCHAR2 DEFAULT 'Report',
                                p_table_class IN VARCHAR2 DEFAULT 'uReport') IS

        l_yyyymm_prev VARCHAR2(6) := substr(p_yyyymm, 1, 4) ||
                                     lpad(to_char(to_number(substr(p_yyyymm, 5, 2)) - 1), 2, '0');

        CURSOR c_val(p_yyyymm  IN VARCHAR2,
                     p_factno  IN VARCHAR2,
                     p_bu_code IN VARCHAR2,
                     p_sku_no  IN VARCHAR2) IS
        
            SELECT b.ftype, a.val, a.val_add
              FROM (SELECT v5 ftype, n1 AS val, n2 AS val_add
                       FROM blm_temp
                      WHERE v1 = p_yyyymm
                        AND v2 = p_factno
                        AND v3 = p_bu_code
                        AND v4 = p_sku_no
                        AND session_id = g_session
                        AND main_code = 'VAL') a
             RIGHT JOIN (SELECT v5 AS ftype
                           FROM blm_temp
                          WHERE main_code = 'VAL'
                            AND session_id = g_session
                          GROUP BY v5) b
                ON a.ftype = b.ftype
             ORDER BY 1;

        CURSOR c_keep_col IS
            SELECT v1 AS yyyymm, v2 AS factno, v11 AS factname, v3 AS bu_code,
                   v12 AS bu_name, v4 AS sku_no, v19 AS sku_name
              FROM blm_temp
             WHERE main_code = 'VAL'
               AND session_id = g_session
             GROUP BY v1, v2, v11, v3, v12, v4, v6, v19
             ORDER BY v1, v2, v3, v6;

        CURSOR c_head IS
            WITH b AS
             (SELECT '1BOB' AS fno, '期初库存' AS fname
                FROM dual
              UNION ALL
              SELECT '2SALE', '销量'
                FROM dual
              UNION ALL
              SELECT '3' || entitycode AS dept_no, entityname AS dept_name
                FROM blm_entity
               WHERE yyyy = p_yyyy
              UNION ALL
              SELECT '4' || branch_no, '被' || branch_name || '支援'
                FROM erp_pub112t0
              UNION ALL
              SELECT '5' || branch_no, '支援 ' || branch_name FROM erp_pub112t0)
            SELECT v5 AS ftype,
                   (SELECT b.fname FROM b WHERE b.fno = a.v5) AS fname
              FROM blm_temp a
             WHERE main_code = 'VAL'
               AND session_id = g_session
             GROUP BY v5
             ORDER BY 1;

        l_val  NUMBER DEFAULT 0;
        l_clob CLOB;
        l_cnt  NUMBER DEFAULT 0;
    BEGIN

        -- 清除临时表
        clear_temp(p_main_codes => 'FACT_AREA,REV7,VAL');

        INSERT INTO blm_temp
            (main_code, session_id, v1, v2, v3, v4)
            SELECT 'FACT_AREA', g_session, factno, area_no, bu_code, yyyy
              FROM region_factno
             WHERE yyyy = p_yyyy
               AND version_id = p_version
               AND region_code = 'ALL'
               AND factno LIKE p_fact || '%'
             GROUP BY factno, area_no, yyyy, bu_code;

        INSERT INTO blm_temp
            (main_code, session_id, v1, v2, v3, v4, v5, n1)
        
            SELECT 'REV7', g_session, a.detc_code, c.bu_code, NULL AS area_no,
                   c.factno, a.yyyymm, round(SUM(a.amt), 2) AS qty
              FROM blm100t0 a
              JOIN mv_sku h
                ON a.detc_code = h.sku_no
               AND h.mark_plan IS NOT NULL
              JOIN region_factno c
                ON a.region_no = c.region_code
             WHERE a.mark = '7'
               AND a.mark_keyin = '2'
               AND c.bu_code = h.clus_no
                  --AND c.area_no = p_area
               AND a.region_no <> 'ALL'
               AND c.bu_code LIKE p_clus || '%'
               AND a.yyyymm = p_yyyymm
               AND a.version_id = p_version
               AND a.yyyy = c.yyyy
               AND a.version_id = c.version_id
               AND a.yyyy = p_yyyy
               AND a.amt <> 0
               AND EXISTS (SELECT 1
                      FROM region_factno d
                     WHERE c.factno = d.factno
                       AND d.area_no = p_area
                       AND d.factno LIKE p_fact || '%'
                       AND c.bu_code = d.bu_code
                       AND c.version_id = c.version_id
                       AND d.version_id = p_version
                       AND d.region_code = 'ALL')
             GROUP BY a.detc_code, c.bu_code, c.factno, a.yyyymm
            UNION ALL
            SELECT 'REV7', g_session, a.detc_code, h.clus_no, NULL AS area_no,
                   c.factno, a.yyyymm, round(SUM(a.amt), 2) AS qty
              FROM blm100t0 a
              JOIN mv_sku h
                ON a.detc_code = h.sku_no
               AND h.mark_plan IS NOT NULL
              JOIN blm_entity c
                ON a.branch_no = c.entitycode
             WHERE a.mark = '7'
               AND a.mark_keyin = '2'
               AND a.region_no = 'ALL'
               AND a.yyyymm = p_yyyymm
               AND a.version_id = p_version
               AND a.yyyy = c.yyyy
               AND a.yyyy = p_yyyy
               AND a.amt <> 0
               AND EXISTS (SELECT 1
                      FROM region_factno d
                     WHERE c.factno = d.factno
                       AND d.area_no = p_area
                       AND d.factno LIKE p_fact || '%'
                       AND h.clus_no = d.bu_code
                       AND d.version_id = p_version
                       AND d.region_code = 'ALL')
             GROUP BY a.detc_code, h.clus_no, c.factno, a.yyyymm;

        INSERT INTO blm_temp
            (main_code, session_id, v1, v2, v11, v3, v12, v4, v19, v6, v5, n1,
             n2)
            SELECT 'VAL', g_session, t.yyyymm, t.factno, c.branch_name, b.bu_no,
                   b.bu_nm, coalesce(t.sku_no, '<b>合计</b>') AS sku_no, b.sku_nm,
                   CASE
                       WHEN t.sku_no IS NULL THEN
                        'B'
                       ELSE
                        'A'
                   END sku_seq, t.ftype, SUM(t.qty), SUM(t.qty * t.fadd)
              FROM (SELECT p_yyyymm AS yyyymm, a.dept_no AS factno,
                            a.prod_no AS sku_no, a.qty, '1BOB' AS ftype, 1 AS fadd
                       FROM blm500t0 a, mv_sku b
                      WHERE a.yyyymm = l_yyyymm_prev
                        AND a.prod_no = b.sku_no
                        AND a.version_id = p_version
                        AND b.mark_plan IS NOT NULL
                        AND b.clus_no LIKE p_clus || '%'
                        AND a.mark = '2'
                        AND EXISTS (SELECT 1
                               FROM blm_temp c
                              WHERE c.main_code = 'FACT_AREA'
                                AND c.session_id = g_session
                                AND a.dept_no = c.v1
                                AND a.yyyy = c.v4
                                AND b.clus_no = c.v3
                                AND c.v2 = p_area)
                     UNION ALL
                     SELECT p_yyyymm AS yyyymm, a.factno, a.prod_no AS sku_no,
                            a.qty, '1BOB' AS ftype, 1 AS fadd
                       FROM blm500t0 a, mv_sku b
                      WHERE a.yyyymm = p_yyyy || '01'
                        AND a.yyyymm = p_yyyymm
                        AND a.version_id = p_version
                        AND a.prod_no = b.sku_no
                        AND b.mark_plan IS NOT NULL
                        AND b.clus_no LIKE p_clus || '%'
                        AND a.mark = '1'
                        AND EXISTS (SELECT 1
                               FROM blm_temp c
                              WHERE c.main_code = 'FACT_AREA'
                                AND c.session_id = g_session
                                AND a.factno = c.v1
                                AND a.yyyy = c.v4
                                AND b.clus_no = c.v3
                                AND c.v2 = p_area)
                     
                     UNION ALL
                     SELECT a.v5, a.v4, a.v1, a.n1 qty, '2SALE' AS ftype,
                            -1 AS fadd
                       FROM blm_temp a
                      WHERE a.v5 = p_yyyymm
                        AND a.v2 LIKE p_clus || '%'
                        AND a.main_code = 'REV7'
                        AND a.session_id = g_session
                     UNION ALL
                     SELECT a.yyyymm, a.factno, a.sku_no, a.qty,
                            '3' || a.dept_no AS ftype, 1 AS fadd
                       FROM blm600t0 a, mv_sku b
                      WHERE a.mark = '1'
                        AND a.oem_mark IN ('1', '21', '22')
                        AND a.yyyymm = p_yyyymm
                        AND a.version_id = p_version
                        AND a.sku_no = b.sku_no
                        AND b.mark_plan IS NOT NULL
                        AND b.clus_no LIKE p_clus || '%'
                        AND EXISTS (SELECT 1
                               FROM blm_temp c
                              WHERE c.main_code = 'FACT_AREA'
                                AND c.session_id = g_session
                                AND a.factno = c.v1
                                AND a.yyyy = c.v4
                                AND b.clus_no = c.v3
                                AND c.v2 = p_area)
                     UNION ALL
                     SELECT a.yyyymm, a.factno, a.sku_no, a.qty,
                            '5' || a.rel_factno AS ftype, -1 AS fadd
                       FROM blm600t0 a, mv_sku b
                      WHERE a.mark = '1'
                        AND a.oem_mark IN ('1', '21', '22')
                        AND a.rel_factno <> 'ALL'
                        AND b.mark_plan IS NOT NULL
                        AND a.yyyymm = p_yyyymm
                        AND a.version_id = p_version
                        AND a.sku_no = b.sku_no
                        AND b.clus_no LIKE p_clus || '%'
                        AND EXISTS (SELECT 1
                               FROM blm_temp c
                              WHERE c.main_code = 'FACT_AREA'
                                AND c.session_id = g_session
                                AND a.factno = c.v1
                                AND a.yyyy = c.v4
                                AND b.clus_no = c.v3
                                AND c.v2 = p_area)
                     UNION ALL
                     SELECT a.yyyymm, a.rel_factno, a.sku_no, a.qty,
                            '4' || a.factno AS ftype, 1 AS fadd
                       FROM blm600t0 a, mv_sku b
                      WHERE a.mark = '1'
                        AND a.oem_mark IN ('1', '21', '22')
                        AND b.mark_plan IS NOT NULL
                        AND a.yyyymm = p_yyyymm
                        AND a.version_id = p_version
                        AND a.sku_no = b.sku_no
                        AND b.clus_no LIKE p_clus || '%'
                        AND a.rel_factno <> 'ALL'
                        AND EXISTS (SELECT 1
                               FROM blm_temp c
                              WHERE c.main_code = 'FACT_AREA'
                                AND c.session_id = g_session
                                AND a.rel_factno = c.v1
                                AND a.yyyy = c.v4
                                AND b.clus_no = c.v3
                                AND c.v2 = p_area)) t, mv_sku b, erp_pub112t0 c
             WHERE t.sku_no = b.sku_no
               AND t.factno = c.branch_no
               AND b.mark_plan IS NOT NULL
             GROUP BY GROUPING SETS((t.yyyymm, t.factno, c.branch_name, b.bu_no, b.bu_nm, t.ftype),(t.yyyymm, t.factno, c.branch_name, t.sku_no, b.sku_nm, b.bu_no, b.bu_nm, t.ftype));

        -- meta and head
        p_print_meta(p_request_in => p_request, p_filename_in => p_filename);
        p_print_head(p_request_in => p_request);

        htp.prn('<table class="' || p_table_class || '">');

        htp.prn('<thead>');

        FOR h IN c_head LOOP
            l_cnt  := l_cnt + 1;
            l_clob := l_clob || '<th>' || h.fname || '</th>';
        END LOOP;

        IF l_cnt > 0 THEN
            l_clob := '<th>版本</th><th>月份</th><th>子公司</th><th>BU</th><th>SKU编号</th><th>SKU名称</th>' ||
                      l_clob || '<th>结存</th>';
            htp.prn(l_clob);
        END IF;

        htp.prn('</thead>');

        FOR k IN c_keep_col LOOP
        
            htp.prn('<tr>');
            htp.prn(wrap_cell(p_version) ||
                    wrap_cell(k.yyyymm) || '<td>' || k.factname || '</td>' ||
                    '<td>' || k.bu_name || '</td>' || '<td>' || k.sku_no ||
                    '</td>' || '<td>' || k.sku_name || '</td>');
        
            l_val := 0;
            FOR v IN c_val(p_yyyymm => k.yyyymm, p_factno => k.factno, p_bu_code => k.bu_code, p_sku_no => k.sku_no) LOOP
            
                htp.prn('<td class="number">' ||
                        to_char(v.val, '999G999G999G999D00') || '</td>');
                l_val := l_val + coalesce(v.val_add, 0);
            END LOOP;
            htp.prn('<td class="number">' ||
                    to_char(l_val, '999G999G999G999D00') || '</td>');
            htp.prn('</tr>');
        END LOOP;
        htp.prn('</table>');

        IF l_cnt > 0 THEN
            p_print_downloadlink(p_request_in => p_request);
        END IF;
        -- 
        htp.prn('</html>');
        p_stop_print(p_request_in => p_request);

    END;

    PROCEDURE show_report_aps_4(p_yyyy        IN VARCHAR2,
                                p_version     IN VARCHAR2,
                                p_request     IN VARCHAR2 DEFAULT 'GO',
                                p_filename    IN VARCHAR2 DEFAULT 'Report',
                                p_table_class IN VARCHAR2 DEFAULT 'uReport') IS
        CURSOR c(p_yyyymm IN VARCHAR2) IS
            WITH t AS
             (
              -- 销量
              SELECT a.v5 AS yyyymm, a.v3 AS area_no, v13 AS area_name,
                      a.v4 AS factno, v14 AS fact_name, a.v2 AS clus_no,
                      a.v12 AS clus_nm, a.v1 AS sku_no, a.v11 AS sku_nm, a.n1 qty,
                      '销量' AS flabel, 'B 销量' AS ftype, -1 AS fadd
                FROM gt_temp a
               WHERE a.main_code = 'REV72'
                 AND a.v5 = p_yyyymm
              UNION ALL
              
              SELECT m.yyyymm, n.v2 AS area_no, n.v12 AS area_name, m.factno,
                     n.v11 AS fact_name, m.clus_no, m.clus_nm, m.sku_no, m.sku_nm,
                     m.qty, m.flabel, m.ftype, m.fadd
                FROM (
                       -- 期初
                       SELECT p_yyyymm AS yyyymm, a.dept_no AS factno, b.clus_no,
                               b.clus_nm, a.prod_no AS sku_no, b.sku_nm, a.qty,
                               '期初库存' AS flabel, 'A 期初库存' AS ftype, 1 AS fadd
                         FROM blm500t0 a, mv_sku b
                        WHERE a.prod_no = b.sku_no
                          AND b.mark_plan IS NOT NULL
                          AND a.yyyymm =
                              to_char(add_months(to_date(p_yyyymm, 'yyyymm'), -1), 'yyyymm')
                          AND a.mark = '2'
                       UNION ALL
                       SELECT p_yyyymm AS yyyymm, a.factno, b.clus_no, b.clus_nm,
                              a.prod_no AS sku_no, b.sku_nm, a.qty, '期初库存' AS flabel,
                              'A 期初库存' AS ftype, 1 AS fadd
                         FROM blm500t0 a, mv_sku b
                        WHERE a.yyyymm = p_yyyy || '01'
                          AND a.yyyymm = p_yyyymm
                          AND a.prod_no = b.sku_no
                          AND b.mark_plan IS NOT NULL
                          AND a.mark = '1'
                       UNION ALL
                       -- 自产
                       SELECT a.yyyymm, a.factno, b.clus_no, b.clus_nm, a.sku_no,
                              b.sku_nm, a.qty,
                              (SELECT e.entityname
                                  FROM blm_entity e
                                 WHERE e.entitycode = a.dept_no
                                   AND e.yyyy = a.yyyy) AS flabel, 'C 本厂生产' AS ftype,
                              1 AS fadd
                         FROM blm600t0 a, mv_sku b
                        WHERE a.mark = '1'
                          AND a.oem_mark IN ('1', '21', '22')
                          AND b.mark_plan IS NOT NULL
                          AND a.yyyymm = p_yyyymm
                          AND a.version_id = p_version
                          AND a.sku_no = b.sku_no
                       UNION ALL
                       SELECT a.yyyymm, a.rel_factno, b.clus_no, b.clus_nm, a.sku_no,
                              b.sku_nm, a.qty,
                              (SELECT e.branch_name
                                  FROM erp_pub112t0 e
                                 WHERE e.branch_no = a.factno) AS flabel,
                              'D 被支援' AS ftype, 1 AS fadd
                         FROM blm600t0 a, mv_sku b
                        WHERE a.mark = '1'
                          AND a.oem_mark IN ('1', '21', '22')
                          AND b.mark_plan IS NOT NULL
                          AND a.yyyymm = p_yyyymm
                          AND a.version_id = p_version
                          AND a.sku_no = b.sku_no
                       UNION ALL
                       SELECT a.yyyymm, a.factno, b.clus_no, b.clus_nm, a.sku_no,
                              b.sku_nm, a.qty,
                              (SELECT e.branch_name
                                  FROM erp_pub112t0 e
                                 WHERE e.branch_no = a.rel_factno) AS flabel,
                              'E 支援友厂' AS ftype, -1 AS fadd
                         FROM blm600t0 a, mv_sku b
                        WHERE a.mark = '1'
                          AND a.oem_mark IN ('1', '21', '22')
                          AND a.rel_factno <> 'ALL'
                          AND b.mark_plan IS NOT NULL
                          AND a.yyyymm = p_yyyymm
                          AND a.version_id = p_version
                          AND a.sku_no = b.sku_no) m, gt_temp n
               WHERE n.main_code = 'FACT_AREA2'
                 AND m.factno = n.v1
                 AND m.clus_no = n.v3
              
              )
            
            SELECT yyyymm, area_no, area_name, factno, fact_name, clus_no,
                   clus_nm, sku_no, sku_nm, flabel, ftype, SUM(qty) AS qty
              FROM t
             GROUP BY yyyymm, area_no, area_name, factno, fact_name, clus_no,
                      clus_nm, sku_no, sku_nm, flabel, ftype
            UNION ALL
            SELECT yyyymm, area_no, area_name, factno, fact_name, clus_no,
                   clus_nm, sku_no, sku_nm, '结存' AS flabel, 'F 结存' AS ftype,
                   SUM(qty * fadd) AS qty
              FROM t
             GROUP BY yyyymm, area_no, area_name, factno, fact_name, clus_no,
                      clus_nm, sku_no, sku_nm
             ORDER BY yyyymm, area_no, factno, clus_no, sku_no, ftype;

        l_val    NUMBER DEFAULT 0;
        l_clob   CLOB;
        l_cnt    NUMBER DEFAULT 0;
        l_yyyymm VARCHAR2(6);
    BEGIN
        clear_gt_temp(p_main_codes => 'FACT_AREA2,REGI_AREA2,REV72');

        INSERT INTO gt_temp
            (main_code, v1, v11, v2, v12, v3, v4)
            SELECT 'FACT_AREA2', a.factno,
                   (SELECT b.branch_name
                       FROM erp_pub112t0 b
                      WHERE b.branch_no = a.factno), a.area_no,
                   (SELECT c.branch_name
                       FROM erp_pub112t0 c
                      WHERE c.branch_no = a.area_no), a.bu_code, a.yyyy
              FROM region_factno a
             WHERE a.yyyy = p_yyyy
               AND a.version_id = p_version
               AND a.region_code = 'ALL'
             GROUP BY a.factno, a.area_no, a.yyyy, a.bu_code
             ORDER BY a.area_no;

        INSERT INTO gt_temp
            (main_code, v1, v11, v2, v12, v3, v4, v5)
            SELECT 'REGI_AREA2', factno,
                   (SELECT d.branch_name
                       FROM erp_pub112t0 d
                      WHERE d.branch_no = a.factno) AS fact_name, area_no,
                   (SELECT e.branch_name
                       FROM erp_pub112t0 e
                      WHERE e.branch_no = a.area_no) AS area_name, a.bu_code,
                   a.yyyy, a.region_code
              FROM (SELECT a.factno,
                            (SELECT b.area_no
                                FROM region_factno b
                               WHERE b.region_code = 'ALL'
                                 AND a.yyyy = b.yyyy
                                 AND b.yyyy = p_yyyy
                                 AND b.version_id = p_version
                                 AND a.factno = b.factno
                                 AND a.bu_code = b.bu_code) AS area_no, a.bu_code,
                            a.yyyy, a.region_code
                       FROM region_factno a
                      WHERE a.yyyy = p_yyyy) a;

        -- meta and head
        p_print_meta(p_request_in => p_request, p_filename_in => p_filename);
        p_print_head(p_request_in => p_request);

        FOR j IN 1 .. 12 LOOP
            l_yyyymm := p_yyyy || lpad(j, 2, '0');
        
            clear_gt_temp(p_main_codes => 'REV72');
        
            INSERT INTO gt_temp
                (main_code, v1, v11, v2, v12, v3, v13, v4, v14, v5, n1)
            
                SELECT 'REV72', a.detc_code, h.sku_nm, c.v3 AS bu_code,
                       h.clus_nm, c.v2 AS area_no, c.v12 AS area_name,
                       c.v1 AS factno, c.v11 AS fact_name, a.yyyymm,
                       round(SUM(a.amt), 2) AS qty
                  FROM blm100t0 a, mv_sku h, gt_temp c
                 WHERE a.detc_code = h.sku_no
                   AND a.region_no = c.v5
                   AND a.region_no <> 'ALL'
                   AND h.clus_no = c.v3
                   AND c.main_code = 'REGI_AREA2'
                   AND a.mark = '7'
                   AND a.mark_keyin = '2'
                   AND h.mark_plan IS NOT NULL
                   AND a.yyyymm = l_yyyymm
                   AND a.version_id = p_version
                   AND a.yyyy = p_yyyy
                   AND a.amt <> 0
                 GROUP BY a.detc_code, h.sku_nm, c.v3, h.clus_nm, c.v2, c.v12,
                          c.v1, c.v11, a.yyyymm
                UNION ALL
                SELECT 'REV72', a.detc_code, h.sku_nm, h.clus_no AS bu_code,
                       h.clus_nm, d.branch_no AS area_no,
                       d.branch_name AS area_name, c.factno AS factno,
                       f.branch_name AS fact_name, a.yyyymm,
                       round(SUM(a.amt), 2) AS qty
                  FROM blm100t0 a, mv_sku h, blm_entity c, erp_pub112t0 d,
                       erp_pub112t0 f
                 WHERE a.detc_code = h.sku_no
                   AND a.region_no = 'ALL'
                   AND a.mark = '7'
                   AND a.mark_keyin = '2'
                   AND h.mark_plan IS NOT NULL
                   AND a.yyyymm = l_yyyymm
                   AND a.yyyy = p_yyyy
                   AND a.version_id = p_version
                   AND a.amt <> 0
                   AND c.factno = f.branch_no
                   AND a.branch_no = c.entitycode
                   AND EXISTS (SELECT 1
                          FROM region_factno e
                         WHERE e.factno = c.factno
                           AND e.area_no = d.branch_no
                           AND e.bu_code = h.clus_no
                           AND e.yyyy = p_yyyy
                           AND e.region_code = 'ALL')
                 GROUP BY a.detc_code, h.sku_nm, h.clus_no, h.clus_nm,
                          d.branch_no, d.branch_name, c.factno, f.branch_name,
                          a.yyyymm;
        
            htp.prn('<table class="' || p_table_class || '">');
            htp.prn('<thead>');
        
            htp.prn('<th>年度</th><th>版本</th><th>月份</th><th>区域</th><th>子公司</th><th>BU</th><th>SKU编号</th><th>SKU名称</th><th>标签</th><th>类别</th><th>数量</th>');
        
            htp.prn('</thead>');
        
            FOR k IN c(l_yyyymm) LOOP
            
                htp.prn('<tr>');
                htp.prn('<td>' || p_yyyy || '</td>' || '<td>' || p_version ||
                        '</td>' || '<td>' || k.yyyymm || '</td>' || '<td>' ||
                        k.area_name || '<td>' || k.fact_name || '</td>' ||
                        '<td>' || k.clus_nm || '</td>' || '<td>' || k.sku_no ||
                        '</td>' || '<td>' || k.sku_nm || '</td>' || '<td>' ||
                        k.flabel || '</td>' || '<td>' || k.ftype || '</td>' ||
                        '<td class="number">' || k.qty || '</td>');
                htp.prn('</tr>');
            END LOOP;
            htp.prn('</table>');
        END LOOP;

        --
        p_print_downloadlink(p_request_in => p_request);
        -- 
        htp.prn('</html>');
        p_stop_print(p_request_in => p_request);
    END;
--
--

END epm_report;
/
