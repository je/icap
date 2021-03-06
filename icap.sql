USE [ICAP_Prod]
GO
/****** Object:  Table [dbo].[icap_actions]    Script Date: 3/16/2015 10:05:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[icap_actions](
	[action_id] [int] IDENTITY(1,1) NOT NULL,
	[action_type] [varchar](50) NULL,
	[action_page] [varchar](max) NULL,
	[action_by_eauth] [varchar](50) NULL,
	[action_by_theid] [varchar](50) NULL,
	[action_by_email] [varchar](50) NULL,
	[action_by_first_name] [varchar](50) NULL,
	[action_by_last_name] [varchar](50) NULL,
	[updated] [datetime] NULL,
 CONSTRAINT [PK_icap_actions] PRIMARY KEY CLUSTERED 
(
	[action_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[icap_applicants]    Script Date: 3/16/2015 10:05:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[icap_applicants](
	[applicant_id] [int] IDENTITY(1,1) NOT NULL,
	[applicant_eauth_id] [varchar](100) NOT NULL,
	[applicant_name] [varchar](100) NULL,
	[applicant_nameI] [varchar](50) NULL,
	[applicant_nameII] [varchar](50) NULL,
	[applicant_nameIII] [varchar](50) NULL,
	[applicant_IQCS] [varchar](50) NULL,
	[applicant_qualifications] [text] NULL,
	[applicant_retired] [varchar](50) NULL,
	[applicant_agency] [varchar](100) NULL,
	[applicant_agency_address] [text] NULL,
	[applicant_city] [varchar](50) NULL,
	[applicant_country] [varchar](50) NULL,
	[applicant_area] [varchar](50) NULL,
	[applicant_zip_code] [varchar](50) NULL,
	[applicant_dispatch_agency] [varchar](200) NULL,
	[applicant_agreement_holder_agency] [varchar](100) NULL,
	[applicant_email_address] [varchar](50) NULL,
	[applicant_work_phone] [varchar](50) NULL,
	[applicant_home_phone] [varchar](50) NULL,
	[applicant_cell_phone] [varchar](50) NULL,
	[applicant_pager_number] [varchar](50) NULL,
	[applicant_dispatch_phone] [varchar](50) NULL,
	[applicant_fax_phone] [varchar](50) NULL,
	[applicant_jet_port] [varchar](50) NULL,
	[applicant_weight] [varchar](50) NULL,
	[applicant_ao_name] [varchar](50) NULL,
	[applicant_ao_email] [varchar](50) NULL,
	[applicant_ao_allowed] [char](1) NULL,
	[applicant_ao_allowed_oa] [char](1) NULL,
	[applicant_aa_name] [varchar](50) NULL,
	[applicant_aa_email] [varchar](50) NULL,
	[applicant_fq_email_type] [varchar](50) NULL,
	[applicant_gaac_type] [varchar](150) NULL,
	[applicant_gaac_typeI] [varchar](150) NULL,
	[applicant_fq_email] [varchar](150) NULL,
	[application_curr_year] [varchar](1) NULL,
	[applicant_intl_al] [varchar](50) NULL,
	[applicant_intl_yr] [varchar](50) NULL,
	[applicant_intl_lf] [varchar](50) NULL,
	[applicant_intl_lc] [varchar](50) NULL,
	[applicant_remarks] [text] NULL,
	[applicant_complete] [char](1) NULL,
	[updated] [datetime] NULL,
	[updated_by] [varchar](100) NULL,
 CONSTRAINT [PK_icap_applicants] PRIMARY KEY CLUSTERED 
(
	[applicant_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[icap_applicants_intl]    Script Date: 3/16/2015 10:05:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[icap_applicants_intl](
	[applicant_intl_id] [int] IDENTITY(1,1) NOT NULL,
	[applicant_id] [int] NULL,
	[applicant_intl_num] [int] NULL,
	[applicant_intl_al] [varchar](50) NULL,
	[applicant_intl_yr] [varchar](50) NULL,
	[applicant_intl_tp] [varchar](50) NULL,
	[applicant_intl_lf] [varchar](50) NULL,
	[applicant_intl_lc] [varchar](50) NULL,
	[applicant_intl_pp] [varchar](50) NULL,
	[applicant_intl_ap] [varchar](50) NULL,
	[applicant_intl_cj] [varchar](50) NULL,
	[updated] [datetime] NULL,
	[updated_by] [varchar](100) NULL,
 CONSTRAINT [PK_icap_applicants_intl] PRIMARY KEY CLUSTERED 
(
	[applicant_intl_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[icap_applications]    Script Date: 3/16/2015 10:05:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[icap_applications](
	[application_id] [int] IDENTITY(1,1) NOT NULL,
	[applicant_id] [int] NULL,
	[position_id] [int] NULL,
	[position_warrant] [varchar](50) NULL,
	[position_po] [varchar](50) NULL,
	[pool_id] [int] NULL,
	[pool_position_id] [int] NULL,
	[application_consideration] [varchar](50) NULL,
	[application_accept_deny] [varchar](50) NULL,
	[application_emailed] [varchar](50) NULL,
	[application_interest] [text] NULL,
	[application_qualifications] [text] NULL,
	[application_curr_year] [varchar](50) NULL,
	[application_recommendation] [text] NULL,
	[application_valid] [varchar](50) NULL,
	[application_type] [varchar](50) NULL,
	[updated] [varchar](50) NULL,
	[updated_by] [varchar](50) NULL,
 CONSTRAINT [PK_icap_applications] PRIMARY KEY CLUSTERED 
(
	[application_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[icap_applications_archive]    Script Date: 3/16/2015 10:05:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[icap_applications_archive](
	[application_id] [int] NULL,
	[applicant_id] [int] NULL,
	[position_id] [int] NULL,
	[position_warrant] [char](1) NULL,
	[position_po] [char](1) NULL,
	[pool_id] [int] NULL,
	[pool_position_id] [int] NULL,
	[application_consideration] [varchar](50) NULL,
	[application_accept_deny] [varchar](50) NULL,
	[application_emailed] [char](1) NULL,
	[application_interest] [text] NULL,
	[application_qualifications] [text] NULL,
	[application_curr_year] [varchar](50) NULL,
	[application_recommendation] [text] NULL,
	[application_valid] [char](1) NULL,
	[application_type] [char](1) NULL,
	[updated] [datetime] NULL,
	[updated_by] [varchar](50) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[icap_areas]    Script Date: 3/16/2015 10:05:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[icap_areas](
	[area_id] [int] IDENTITY(1,1) NOT NULL,
	[area] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[icap_attachments]    Script Date: 3/16/2015 10:05:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[icap_attachments](
	[attachment_id] [int] IDENTITY(1,1) NOT NULL,
	[applicant_id] [int] NULL,
	[attachment_name] [varchar](150) NULL,
	[attachment_original_name] [varchar](150) NULL,
	[attachment_original_size] [varchar](150) NULL,
	[attachment_added] [varchar](150) NULL,
	[attachment_added_by] [varchar](150) NULL,
	[archived] [char](1) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[icap_gaac]    Script Date: 3/16/2015 10:05:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[icap_gaac](
	[gaac_id] [int] NOT NULL,
	[area] [varchar](50) NULL,
	[gaac] [varchar](250) NULL,
	[gaac_code] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[icap_pool_removes]    Script Date: 3/16/2015 10:05:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[icap_pool_removes](
	[pool_remove_id] [int] IDENTITY(1,1) NOT NULL,
	[position_id] [int] NULL,
	[applicant_id] [int] NULL,
	[application_consideration] [varchar](50) NULL,
	[pool_id] [int] NULL,
	[position_title] [varchar](50) NULL,
	[added] [varchar](50) NULL,
	[added_by] [varchar](50) NULL,
 CONSTRAINT [PK_icap_pool_removes] PRIMARY KEY CLUSTERED 
(
	[pool_remove_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[icap_positions]    Script Date: 3/16/2015 10:05:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[icap_positions](
	[position_id] [int] IDENTITY(1,1) NOT NULL,
	[icteam_id] [int] NULL,
	[position_type] [varchar](50) NULL,
	[position_code] [varchar](10) NULL,
	[position_title] [varchar](100) NULL,
	[position_description] [text] NULL,
	[updated] [datetime] NULL,
	[updated_by] [varchar](50) NULL,
 CONSTRAINT [PK_icap_positions] PRIMARY KEY CLUSTERED 
(
	[position_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[icap_positions_applicants]    Script Date: 3/16/2015 10:05:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[icap_positions_applicants](
	[position_applicant_id] [int] IDENTITY(1,1) NOT NULL,
	[position_id] [int] NULL,
	[icteam_id] [int] NULL,
	[applicant_id] [int] NULL,
	[applicant_type] [varchar](50) NULL,
	[applicant_valid] [char](1) NULL,
	[updated] [datetime] NULL,
	[updated_by] [varchar](50) NULL,
	[closed] [datetime] NULL,
	[closed_by] [varchar](50) NULL,
 CONSTRAINT [PK_icap_positions_applicants] PRIMARY KEY CLUSTERED 
(
	[position_applicant_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[icap_positions_applicants_pool]    Script Date: 3/16/2015 10:05:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[icap_positions_applicants_pool](
	[pool_id] [int] IDENTITY(1,1) NOT NULL,
	[position_id] [int] NULL,
	[position_title] [varchar](50) NULL,
	[position_area] [varchar](50) NULL,
	[applicant_id] [int] NULL,
	[application_consideration] [varchar](50) NULL,
	[pool_user] [varchar](100) NULL,
	[archived] [char](1) NULL,
	[updated] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[icap_positions_applicants_pool_archive]    Script Date: 3/16/2015 10:05:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[icap_positions_applicants_pool_archive](
	[pool_id] [int] NULL,
	[position_id] [int] NULL,
	[position_title] [varchar](50) NULL,
	[applicant_id] [int] NULL,
	[application_consideration] [varchar](50) NULL,
	[pool_user] [varchar](100) NULL,
	[archived] [char](1) NULL,
	[updated] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[icap_positions_drops]    Script Date: 3/16/2015 10:05:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[icap_positions_drops](
	[position_drop_id] [int] IDENTITY(1,1) NOT NULL,
	[position_id] [int] NULL,
	[icteam_id] [int] NULL,
	[applicant_id] [int] NULL,
	[updated] [datetime] NULL,
	[updated_by] [varchar](50) NULL,
 CONSTRAINT [PK_icap_positions_drops] PRIMARY KEY CLUSTERED 
(
	[position_drop_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[icap_positions_status]    Script Date: 3/16/2015 10:05:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[icap_positions_status](
	[position_status_id] [int] IDENTITY(1,1) NOT NULL,
	[position_id] [int] NULL,
	[icteam_id] [int] NULL,
	[position_status] [varchar](50) NULL,
	[updated] [datetime] NULL,
	[updated_by] [varchar](50) NULL,
 CONSTRAINT [PK_icap_positions_status] PRIMARY KEY CLUSTERED 
(
	[position_status_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[icap_teams]    Script Date: 3/16/2015 10:05:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[icap_teams](
	[icteam_id] [int] IDENTITY(1,1) NOT NULL,
	[icteam_name] [varchar](50) NULL,
	[icteam_area] [varchar](50) NULL,
	[icteam_buy] [char](1) NULL,
	[updated] [datetime] NULL,
	[updated_by] [varchar](50) NULL,
 CONSTRAINT [PK_icap_teams] PRIMARY KEY CLUSTERED 
(
	[icteam_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[icap_teams_typeIII]    Script Date: 3/16/2015 10:05:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[icap_teams_typeIII](
	[icteam_id] [int] IDENTITY(1,1) NOT NULL,
	[archived_icteam_id] [int] NULL,
	[icteam_name] [varchar](50) NULL,
	[icteam_area] [varchar](50) NULL,
	[updated] [datetime] NULL,
	[updated_by] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
