-- ================== job group and registry ==================
CREATE TABLE xxl_job_group (
                               id              SERIAL          PRIMARY KEY,
                               app_name        VARCHAR(64)     NOT NULL,
                               name            VARCHAR(64)     NOT NULL,
                               address_type    SMALLINT        NOT NULL DEFAULT 0,
                               address_list    TEXT            DEFAULT NULL,
                               access_token    VARCHAR(255)    DEFAULT NULL,
                               update_time     TIMESTAMP       DEFAULT NULL,
                               CONSTRAINT i_app_name UNIQUE (app_name)
);

COMMENT ON TABLE  xxl_job_group IS '执行器信息表';
COMMENT ON COLUMN xxl_job_group.id IS '主键ID';
COMMENT ON COLUMN xxl_job_group.app_name IS '执行器AppName';
COMMENT ON COLUMN xxl_job_group.name IS '执行器名称';
COMMENT ON COLUMN xxl_job_group.address_type IS '执行器地址类型：0=自动注册、1=手动录入';
COMMENT ON COLUMN xxl_job_group.address_list IS '执行器地址列表，多地址逗号分隔';
COMMENT ON COLUMN xxl_job_group.access_token IS '执行器AccessToken';
COMMENT ON COLUMN xxl_job_group.update_time IS '更新时间';

CREATE TABLE xxl_job_registry (
                                  id              BIGSERIAL       PRIMARY KEY,
                                  registry_group  VARCHAR(50)     NOT NULL,
                                  registry_key    VARCHAR(255)    NOT NULL,
                                  registry_value  VARCHAR(255)    NOT NULL,
                                  update_time     TIMESTAMP       DEFAULT NULL,
                                  CONSTRAINT i_g_k_v UNIQUE (registry_group, registry_key, registry_value)
);

COMMENT ON TABLE  xxl_job_registry IS '任务调度注册表';
COMMENT ON COLUMN xxl_job_registry.id IS '主键ID';
COMMENT ON COLUMN xxl_job_registry.registry_group IS '注册组';
COMMENT ON COLUMN xxl_job_registry.registry_key IS '注册key';
COMMENT ON COLUMN xxl_job_registry.registry_value IS '注册value';
COMMENT ON COLUMN xxl_job_registry.update_time IS '更新时间';

-- ================== job info ==================
CREATE TABLE xxl_job_info (
                              id                        SERIAL          PRIMARY KEY,
                              job_group                 INT             NOT NULL,
                              name                      VARCHAR(255)    NOT NULL,
                              author                    VARCHAR(64)     DEFAULT NULL,
                              alarm_email               VARCHAR(255)    DEFAULT NULL,
                              schedule_type             VARCHAR(50)     NOT NULL DEFAULT 'NONE',
                              schedule_conf             VARCHAR(128)    DEFAULT NULL,
                              misfire_strategy          VARCHAR(50)     NOT NULL DEFAULT 'DO_NOTHING',
                              executor_route_strategy   VARCHAR(50)     DEFAULT NULL,
                              executor_handler          VARCHAR(255)    DEFAULT NULL,
                              executor_param            TEXT            DEFAULT NULL,
                              executor_block_strategy   VARCHAR(50)     DEFAULT NULL,
                              executor_timeout          INT             NOT NULL DEFAULT 0,
                              executor_fail_retry_count INT             NOT NULL DEFAULT 0,
                              glue_type                 VARCHAR(50)     NOT NULL,
                              glue_source               TEXT            DEFAULT NULL,
                              glue_remark               VARCHAR(128)    DEFAULT NULL,
                              glue_updatetime           TIMESTAMP       DEFAULT NULL,
                              child_jobid               VARCHAR(255)    DEFAULT NULL,
                              trigger_status            SMALLINT        NOT NULL DEFAULT 0,
                              trigger_last_time         BIGINT          NOT NULL DEFAULT 0,
                              trigger_next_time         BIGINT          NOT NULL DEFAULT 0,
                              add_time                  TIMESTAMP       DEFAULT NULL,
                              update_time               TIMESTAMP       DEFAULT NULL
);

COMMENT ON TABLE  xxl_job_info IS '调度信息表';
COMMENT ON COLUMN xxl_job_info.id IS '主键ID';
COMMENT ON COLUMN xxl_job_info.job_group IS '执行器主键ID';
COMMENT ON COLUMN xxl_job_info.name IS '任务名称';
COMMENT ON COLUMN xxl_job_info.author IS '负责人';
COMMENT ON COLUMN xxl_job_info.alarm_email IS '报警邮件';
COMMENT ON COLUMN xxl_job_info.schedule_type IS '调度类型';
COMMENT ON COLUMN xxl_job_info.schedule_conf IS '调度配置，值含义取决于调度类型';
COMMENT ON COLUMN xxl_job_info.misfire_strategy IS '调度过期策略';
COMMENT ON COLUMN xxl_job_info.executor_route_strategy IS '执行器路由策略';
COMMENT ON COLUMN xxl_job_info.executor_handler IS '执行器任务handler';
COMMENT ON COLUMN xxl_job_info.executor_param IS '执行器任务参数';
COMMENT ON COLUMN xxl_job_info.executor_block_strategy IS '阻塞处理策略';
COMMENT ON COLUMN xxl_job_info.executor_timeout IS '任务执行超时时间，单位秒';
COMMENT ON COLUMN xxl_job_info.executor_fail_retry_count IS '失败重试次数';
COMMENT ON COLUMN xxl_job_info.glue_type IS 'GLUE类型';
COMMENT ON COLUMN xxl_job_info.glue_source IS 'GLUE源代码';
COMMENT ON COLUMN xxl_job_info.glue_remark IS 'GLUE备注';
COMMENT ON COLUMN xxl_job_info.glue_updatetime IS 'GLUE更新时间';
COMMENT ON COLUMN xxl_job_info.child_jobid IS '子任务ID，多个逗号分隔';
COMMENT ON COLUMN xxl_job_info.trigger_status IS '调度状态：0-停止，1-运行';
COMMENT ON COLUMN xxl_job_info.trigger_last_time IS '上次调度时间';
COMMENT ON COLUMN xxl_job_info.trigger_next_time IS '下次调度时间';
COMMENT ON COLUMN xxl_job_info.add_time IS '添加时间';
COMMENT ON COLUMN xxl_job_info.update_time IS '更新时间';

-- ================== job log glue ==================
CREATE TABLE xxl_job_logglue (
                                 id            SERIAL          PRIMARY KEY,
                                 job_id        INT             NOT NULL,
                                 glue_type     VARCHAR(50)     DEFAULT NULL,
                                 glue_source   TEXT            DEFAULT NULL,
                                 glue_remark   VARCHAR(128)    NOT NULL,
                                 add_time      TIMESTAMP       DEFAULT NULL,
                                 update_time   TIMESTAMP       DEFAULT NULL
);

COMMENT ON TABLE  xxl_job_logglue IS '任务GLUE日志表';
COMMENT ON COLUMN xxl_job_logglue.id IS '主键ID';
COMMENT ON COLUMN xxl_job_logglue.job_id IS '任务主键ID';
COMMENT ON COLUMN xxl_job_logglue.glue_type IS 'GLUE类型';
COMMENT ON COLUMN xxl_job_logglue.glue_source IS 'GLUE源代码';
COMMENT ON COLUMN xxl_job_logglue.glue_remark IS 'GLUE备注';
COMMENT ON COLUMN xxl_job_logglue.add_time IS '添加时间';
COMMENT ON COLUMN xxl_job_logglue.update_time IS '更新时间';

-- ================== job log and report ==================
CREATE TABLE xxl_job_log (
                             id                        BIGSERIAL       PRIMARY KEY,
                             job_group                 INT             NOT NULL,
                             job_id                    INT             NOT NULL,
                             executor_address          VARCHAR(255)    DEFAULT NULL,
                             executor_handler          VARCHAR(255)    DEFAULT NULL,
                             executor_param            TEXT            DEFAULT NULL,
                             executor_sharding_param   VARCHAR(20)     DEFAULT NULL,
                             executor_fail_retry_count INT             NOT NULL DEFAULT 0,
                             trigger_time              TIMESTAMP       DEFAULT NULL,
                             trigger_code              INT             NOT NULL,
                             trigger_msg               TEXT            DEFAULT NULL,
                             handle_time               TIMESTAMP       DEFAULT NULL,
                             handle_code               INT             NOT NULL,
                             handle_msg                TEXT            DEFAULT NULL,
                             alarm_status              SMALLINT        NOT NULL DEFAULT 0
);

COMMENT ON TABLE  xxl_job_log IS '任务调度日志表';
COMMENT ON COLUMN xxl_job_log.id IS '主键ID';
COMMENT ON COLUMN xxl_job_log.job_group IS '执行器主键ID';
COMMENT ON COLUMN xxl_job_log.job_id IS '任务主键ID';
COMMENT ON COLUMN xxl_job_log.executor_address IS '执行器地址，本次执行的地址';
COMMENT ON COLUMN xxl_job_log.executor_handler IS '执行器任务handler';
COMMENT ON COLUMN xxl_job_log.executor_param IS '执行器任务参数';
COMMENT ON COLUMN xxl_job_log.executor_sharding_param IS '执行器任务分片参数，格式如 1/2';
COMMENT ON COLUMN xxl_job_log.executor_fail_retry_count IS '失败重试次数';
COMMENT ON COLUMN xxl_job_log.trigger_time IS '调度时间';
COMMENT ON COLUMN xxl_job_log.trigger_code IS '触发结果';
COMMENT ON COLUMN xxl_job_log.trigger_msg IS '触发日志';
COMMENT ON COLUMN xxl_job_log.handle_time IS '处理时间';
COMMENT ON COLUMN xxl_job_log.handle_code IS '处理结果';
COMMENT ON COLUMN xxl_job_log.handle_msg IS '处理日志';
COMMENT ON COLUMN xxl_job_log.alarm_status IS '告警状态：0-默认、1-无需告警、2-告警成功、3-告警失败';

CREATE INDEX i_trigger_time ON xxl_job_log (trigger_time);
CREATE INDEX i_handle_code  ON xxl_job_log (handle_code);
CREATE INDEX i_job_group    ON xxl_job_log (job_group);
CREATE INDEX i_job_id       ON xxl_job_log (job_id);
CREATE INDEX i_alarm_status ON xxl_job_log (alarm_status);

CREATE TABLE xxl_job_log_report (
                                    id            SERIAL          PRIMARY KEY,
                                    trigger_day   TIMESTAMP       DEFAULT NULL,
                                    running_count INT             NOT NULL DEFAULT 0,
                                    suc_count     INT             NOT NULL DEFAULT 0,
                                    fail_count    INT             NOT NULL DEFAULT 0,
                                    update_time   TIMESTAMP       DEFAULT NULL,
                                    CONSTRAINT i_trigger_day UNIQUE (trigger_day)
);

COMMENT ON TABLE  xxl_job_log_report IS '任务调度报表表';
COMMENT ON COLUMN xxl_job_log_report.id IS '主键ID';
COMMENT ON COLUMN xxl_job_log_report.trigger_day IS '调度日期';
COMMENT ON COLUMN xxl_job_log_report.running_count IS '运行中-日志数量';
COMMENT ON COLUMN xxl_job_log_report.suc_count IS '执行成功-日志数量';
COMMENT ON COLUMN xxl_job_log_report.fail_count IS '执行失败-日志数量';
COMMENT ON COLUMN xxl_job_log_report.update_time IS '更新时间';

-- ================== lock ==================
CREATE TABLE xxl_job_lock (
                              lock_name VARCHAR(50) NOT NULL PRIMARY KEY
);

COMMENT ON TABLE  xxl_job_lock IS '任务调度锁表';
COMMENT ON COLUMN xxl_job_lock.lock_name IS '锁名称';

-- ================== user ==================
CREATE TABLE xxl_job_user (
                              id          SERIAL          PRIMARY KEY,
                              username    VARCHAR(50)     NOT NULL,
                              password    VARCHAR(100)    NOT NULL,
                              token       VARCHAR(100)    DEFAULT NULL,
                              role        SMALLINT        NOT NULL,
                              permission  VARCHAR(255)    DEFAULT NULL,
                              CONSTRAINT i_username UNIQUE (username)
);

COMMENT ON TABLE  xxl_job_user IS '系统用户表';
COMMENT ON COLUMN xxl_job_user.id IS '主键ID';
COMMENT ON COLUMN xxl_job_user.username IS '账号';
COMMENT ON COLUMN xxl_job_user.password IS '密码';
COMMENT ON COLUMN xxl_job_user.token IS '登录token';
COMMENT ON COLUMN xxl_job_user.role IS '角色：0-普通用户、1-管理员';
COMMENT ON COLUMN xxl_job_user.permission IS '权限：执行器ID列表，多个逗号分割';

-- ================== default data ==================
INSERT INTO xxl_job_group (id, app_name, name, address_type, address_list, access_token, update_time)
VALUES
    (1, 'xxl-job-executor-sample',    '通用执行器Sample', 0, NULL, 'default_token', NOW()),
    (2, 'xxl-job-executor-sample-ai', 'AI执行器Sample',   0, NULL, 'default_token', NOW());

SELECT setval('xxl_job_group_id_seq', 2);

INSERT INTO xxl_job_info (id, job_group, name, add_time, update_time, author, alarm_email,
                          schedule_type, schedule_conf, misfire_strategy, executor_route_strategy,
                          executor_handler, executor_param, executor_block_strategy, executor_timeout,
                          executor_fail_retry_count, glue_type, glue_source, glue_remark, glue_updatetime, child_jobid)
VALUES
    (1, 1, '示例任务01', NOW(), NOW(), 'XXL', '', 'CRON', '0 0 0 * * ? *',
     'DO_NOTHING', 'FIRST', 'demoJobHandler', '', 'SERIAL_EXECUTION', 0, 0, 'BEAN', '', 'GLUE代码初始化', NOW(), ''),
    (2, 2, 'Ollama示例任务', NOW(), NOW(), 'XXL', '', 'NONE', '',
     'DO_NOTHING', 'FIRST', 'ollamaJobHandler', '{"input":"Java实现二叉树层序遍历","prompt":"你是一个研发工程师，擅长解决技术类问题。","model":"qwen3.5:0.8b"}',
     'SERIAL_EXECUTION', 0, 0, 'BEAN', '', 'GLUE代码初始化', NOW(), ''),
    (3, 2, 'Dify示例任务', NOW(), NOW(), 'XXL', '', 'NONE', '',
     'DO_NOTHING', 'FIRST', 'difyWorkflowJobHandler', '{"inputs":{"input":"查询班级各学科前三名"},"user":"xxl-job","baseUrl":"http://localhost/v1","apiKey":"app-OUVgNUOQRIMokfmuJvBJoUTN"}',
     'SERIAL_EXECUTION', 0, 0, 'BEAN', '', 'GLUE代码初始化', NOW(), ''),
    (4, 2, 'OpenClaw示例任务', NOW(), NOW(), 'XXL', '', 'NONE', '',
     'DO_NOTHING', 'FIRST', 'openClawJobHandler', '{"input":"查看下上海今天得天气，给出出游建议","prompt":"你是一个出游助手，擅长做旅游规划"}',
     'SERIAL_EXECUTION', 0, 0, 'BEAN', '', 'GLUE代码初始化', NOW(), '');

SELECT setval('xxl_job_info_id_seq', 4);

INSERT INTO xxl_job_user (id, username, password, role, permission)
VALUES (1, 'admin', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 1, NULL);

SELECT setval('xxl_job_user_id_seq', 1);

INSERT INTO xxl_job_lock (lock_name) VALUES ('schedule_lock');