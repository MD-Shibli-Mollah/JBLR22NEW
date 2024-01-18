*-----------------------------------------------------------------------------
* <Rating>-7</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE JBL.ARV.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine JBL.ARV.FIELDS
*
* @author erian@fortress-global.com
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
    CALL Table.defineId("REC.ID", T24_String) ;* Define Table id
    CALL Field.setCheckFile('FUNDS.TRANSFER')
*   CALL Table.addField("REC.ID", "", "", "")
    CALL Table.addFieldDefinition("ARV.NUMBER", "30", "A", "")
    CALL Table.addFieldDefinition("DEALER.NAME", "23", "Mercantile Bank Limited", "")
    CALL Table.addFieldDefinition("DEALER.ADDRESS", "35", "A", "") ;*MERCANTILE BANK
    CALL Table.addFieldDefinition("DEALER.CODE", "5", "", "")
    CALL Table.addFieldDefinition("EXP.FORM.NO", "12", "A", "")
    CALL Table.addField("EXPORTER.ID", T24_Customer, "", "")
    CALL Field.setCheckFile('CUSTOMER')
    CALL Table.addFieldDefinition("EXPORTER.NAME", "35", "A", "")
    CALL Table.addFieldDefinition("EXPORTER.ADD", "65", "A", "")
    CALL Table.addFieldDefinition("CCIE.NUMBER", "15", "A", "")
    CALL Table.addFieldDefinition("CCIE.DATE", "12", "D", "")
    CALL Table.addFieldDefinition("EXPORTER.SECTOR", "7", "":FM:"PUBLIC_PRIVATE", "")
    CALL Table.addFieldDefinition("BUYER.NAME", "35", "A", "")
    CALL Table.addFieldDefinition("XX.BUYER.ADD", "65", "A", "")
    CALL Table.addField("XX<COMMODITY.CODE", T24_String, "", "")
    CALL Field.setCheckFile('BD.HS.CODE.LIST')
    CALL Table.addField("XX>COMMODITY.CODE.DES", T24_String, "", "")
    CALL Table.addField("DESTINATION", T24_String, "", "")
    CALL Field.setCheckFile('BD.COUNTRY.CODE')
    CALL Table.addFieldDefinition("RECEIVED.CCY", "3", "CCY", "")
    CALL Table.addFieldDefinition("RECEIVED.CCY.CODE", "7", "A", "")
    CALL Table.addFieldDefinition("RECEIVED.AMOUT", "19", "AMT", "")
    CALL Table.addFieldDefinition("RECEIVED.DATE", "12", "D", "")
    CALL Table.addFieldDefinition("REPORTING.PERIOD", "1", "":FM:"X._Y._0_1_2_3_4_5_6_7_8_9", "")
    CALL Table.addFieldDefinition("REPORTING.PERIOD.DES", "12", "":FM:"JANUARY_FEBRUARY_MARCH_APRIL_MAY_JUNE_JUNE_AUGUST_SEPTEMBER_OCTOBER_NOVEMBER_DECEMBER", "")
*  CALL Table.addFieldWithEbLookup("REPORTING.PERIOD","JBL.ARV.PR","")
* CALL Table.addFieldWithEbLookup("REPORTING.PERIOD.DES","JBL.ARV.PR","")
    CALL Table.addField("DRAWINGS.ID", T24_String, "", "")
    CALL Field.setCheckFile('DRAWINGS')
    CALL Table.addFieldDefinition("DRAWINGS.DT", "12", "D", "")
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
