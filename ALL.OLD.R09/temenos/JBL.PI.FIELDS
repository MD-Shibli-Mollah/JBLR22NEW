*-----------------------------------------------------------------------------
* <Rating>-7</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE JBL.PI.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine JBL.PI.FIELDS
*
* @author tcoleman@temenos.com
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 19/10/07 - EN_10003543
*            New Template changes
*
* 14/11/07 - BG_100015736
*            Exclude routines that are not released
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    dataType = ''
    dataType<2> = "30"
    dataType<3> = "A"
    CALL Table.defineIdProperties("PI.ID",dataType)

* CALL Table.defineId("PI.ID1", T24_String) ;* Define Table id
*-----------------------------------------------------------------------------
    CALL Table.addField("APPLICANT.CUSTNO", T24_Customer, Field_Mandatory, "")
    CALL Field.setCheckFile('CUSTOMER')
    CALL Table.addField("XX.BENEFICIARY", T24_String, "", "")
*    CALL Table.addFieldDefinition("INCO.TERMS", "3", "CIF":FM:"CFR":FM:"FOB":FM:"FCA":FM:"FAS":FM:"CPT":FM:"CIP":FM:"DAF":FM:"DDP":FM:"DDU":FM:"DES":FM:"DEQ":FM:"EXW":FM:"DAT":FM:"DAP","")
    CALL Table.addFieldDefinition("INCO.TERMS", "3", "":FM:"CIF_CFR_FOB_FCA_FAS_CPT_CIP_DAF_DDP_DDU_DES_DEQ_EXW_DAT_DAP","")
    CALL Table.addFieldDefinition("TENOR", "35", "A", "")
    CALL Table.addFieldDefinition("PORT.SHIPMENT", "16", "A", "")
    CALL Table.addFieldDefinition("PORT.DISCHARGE", "16", "A", "")
**************************************************************
    CALL Table.addFieldDefinition("OLD.LC.NUMBER", "16", "A", "")
**************************************************************
    CALL Table.addFieldDefinition("XX<PROINV.NO", "20", "A", "")
    CALL Table.addFieldDefinition("XX-PROINV.DT", "8", "D", "")
    CALL Table.addField("XX-XX<HS.CODE", T24_String, "", "")
    CALL Field.setCheckFile('BD.HS.CODE.LIST')
    CALL Table.addFieldDefinition("XX-XX-COMMODITY", "35", "A", "")
    CALL Table.addFieldDefinition("XX-XX-COMDTY.UN", "3", "S", "")
    CALL Table.addFieldDefinition("XX-XX-COMDT.VOL", "18", "A", "")
    CALL Table.addField("XX-XX-UNIT.PRIC", T24_String, "", "")
    CALL Table.addAmountField("XX-XX>PI.AMT", 'CURRENCY', "", "")
    CALL Table.addFieldDefinition("XX>TAX.NO", "35", "A", "")
    CALL Table.addReservedField('RESERVED.05')
    CALL Table.addReservedField('RESERVED.04')
    CALL Table.addReservedField('RESERVED.03')
    CALL Table.addReservedField('RESERVED.02')
    CALL Table.addReservedField('RESERVED.01')
    CALL Table.addField('XX.LOCAL.REF', T24_String, Field_NoInput,'')
    CALL Table.addOverrideField
*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
