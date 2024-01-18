*-----------------------------------------------------------------------------
* <Rating>-7</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE BD.INT.VIOLATION.PARAM.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine BD.INT.VIOLATION.PARAM.FIELDS
*Developer Info:
*    Date         : 20/02/2022
*    Description  : Fields for the BD.INT.VIOLATION.PARAM template
*    Developed By : Md. Tajul Islam
*    Designation  : Software Engineer
*    Email        : tajul.ntl@nazihargroup.com
*
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*changed some fields type,make maultivalue field,added validation
*    Date         : 27/02/2022
*    Description  : Fields for the BD.INT.VIOLATION.PARAM template
*    Modified By  : Md. Tajul Islam
*    Designation  : Software Engineer
*    Email        : tajul.ntl@nazihargroup.com
*Added fields NOTICE.PERIOD,NOTICE.VALIDITY
*   Date          :30/03/2022
*   Modified By   : Md. Tajul Islam
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("@ID", T24_String) ;* Define Table id
*-----------------------------------------------------------------------------
    CALL Table.addFieldDefinition("Description",35, 'A',"")
    CALL Table.addFieldDefinition("MINIMUM.BALANCE ",18, T24_Numeric,"")
    CALL Table.addField("OPENING.VIODATE", T24_Numeric, "", "")
    CALL Table.addOptionsField("WITHDRAWAL.PERCENTAGE", "1/3_1/4","","")
    CALL Table.addFieldDefinition("WEEKLY.TXNCOUNT", 2, 'A',"")
    CALL Table.addOptionsField("TXNCOUNT.CONDITION","Day_Date","A","")
    CALL Table.addFieldDefinition("XX.TXN.CODE", 8, T24_Numeric,"")
    CALL Field.setCheckFile('TRANSACTION')
    CALL Table.addFieldDefinition("CHANNEL", 35, 'A',"")
    CALL Table.addFieldDefinition("NOTICE.PERIOD",8, T24_Numeric,"")
    CALL Table.addFieldDefinition("NOTICE.VALIDITY",8, T24_Numeric,"")
    CALL Table.addReservedField('RESERVED.05')
    CALL Table.addReservedField('RESERVED.04')
    CALL Table.addReservedField('RESERVED.03')
    CALL Table.addReservedField('RESERVED.02')
    CALL Table.addReservedField('RESERVED.01')

       
*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
