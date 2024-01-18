*-----------------------------------------------------------------------------
* <Rating>-7</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE BD.INT.ACCOUNT.VIOINFO.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine BD.INT.ACCOUNT.VIOINFO.FIELDS
*
*Developer Info:
*    Date         : 27/02/2022
*    Description  : Fields for the BD.INT.ACCOUNT.VIOINFO template
*    Developed By : Md. Nazibul Islam
*    Designation  : Software Engineer
*    Email        : nazibul.ntl@nazihargroup.com
*
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*    Date         : 22/03/2022
*    Description  : Added Date Field to store transaction date
*                 : update Field Length of Day field
*    Modified By  : Md. Tajul Islam
*    Designation  : Software Engineer
*    Email        : tajul.ntl@nazihargroup.com
*
*    Date         :30/03/2023
*Description      : Added NOTICE.VIODATE and NOTICE.VIOFLAG
*    Modified By  : Md. Tajul Islam
*    Designation  : Software Engineer
*    Email        : tajul.ntl@nazihargroup.com
*
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
    CALL Table.addFieldDefinition("XX<WITH.TXNID", "18", T24_String,"")
    CALL Table.addField("XX>WITH.DATE", T24_Date, "", "")
    CALL Table.addFieldDefinition("XX<XX<TRANSACTION.DAY", "9", T24_String,"")
    CALL Table.addField("XX-XX-TRANSACTION.DATE", T24_Date,"", "")
    CALL Table.addFieldDefinition("XX-XX>TRANSACTION.ID", "18", T24_String,"")
    CALL Table.addFieldDefinition("XX>TRANSACTION.COUNT", "8", T24_Numeric,"")
    CALL Table.addYesNoField("FLAG", "", "")
    CALL Table.addField("VIO.DATE", T24_Date, "", "")
*CALL Table.addField(fieldName, fieldType, args, neighbour)
*CALL Table.addYesNoField("NOTICE.VIO.FLAG", "", "")
*-----------------RESERVED-------------
    CALL Table.addReservedField('RESERVED.05')
    CALL Table.addReservedField('RESERVED.04')
    CALL Table.addReservedField('RESERVED.03')
    CALL Table.addReservedField('RESERVED.02')
    CALL Table.addReservedField('RESERVED.01')
*---------------OVERRIDE------------
    CALL Table.addOverrideField
*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
