*-----------------------------------------------------------------------------
* <Rating>-7</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE BD.INT.NOTICE.INFO.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine BD.INT.NOTICE.INFO.FIELDS
*
*Developer Info:
*    Date         : 30/03/2022
*    Description  : Fields for the BD.INT.ACCOUNT.VIOINFO template
*    Developed By : Md. Tajul Islam
*    Designation  : Software Engineer
*    Email        : tajul.ntl@nazihargroup.com
*
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 14/11/07 - BG_100015736
*            Exclude routines that are not released
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
    $USING EB.SystemTables
*** </region>
*-----------------------------------------------------------------------------
    
    CALL Table.defineId("@ID", T24_String) ;* Define Table id
    
*-----------------------------------------------------------------------------
    CALL Table.addField("XX<DATE", T24_Date, Field_Mandatory, "")
    CALL Table.addFieldDefinition("XX-XX<AMOUNT", 15.1, T24_Numeric,"")
    CALL Table.addFieldDefinition("XX>XX>DOC.REF", 15, T24_String,"")
    CALL Table.addField("XX<FROM.DATE", T24_Date,"", "")
    CALL Table.addField("XX-END.DATE", T24_Date, "", "")
    CALL Table.addYesNoField("XX-WITHDRAWL.FLAG", "", "")
    CALL Table.addFieldDefinition("XX>TXN.COUNT",2, T24_Numeric,"")
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
