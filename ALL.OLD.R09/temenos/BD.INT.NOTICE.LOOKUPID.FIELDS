*-----------------------------------------------------------------------------
* <Rating>-7</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE BD.INT.NOTICE.LOOKUPID.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine BD.INT.NOTICE.LOOKUPID.FIELDS
*
* Developed by Tajul Islam
*to keep a record wheather the transaction record exist or not.
*id formate accountnumber*date*amount*last 4 digit of chequeNo(optional)
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
*
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("TABLE.NAME.ID", T24_String) ;* Define Table id
*-----------------------------------------------------------------------------
    CALL Table.addOptionsField("XX.FLAG", "YES_NO","","")
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
