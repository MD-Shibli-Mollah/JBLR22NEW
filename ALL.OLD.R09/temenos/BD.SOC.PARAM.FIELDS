*-----------------------------------------------------------------------------
* <Rating></Rating>
*-----------------------------------------------------------------------------
SUBROUTINE BD.SOC.PARAM.FIELDS
*-----------------------------------------------------------------------------
*<doc>
*Developer Info:
*    Date         : 13/02/2022
*    Description  : Fields for the BD.SOC.PARAM template
*    Developed By : Md. Nazibul Islam
*    Designation  : Software Engineer
*    Email        : nazibul.ntl@nazihargroup.com
*
*
* </doc>
*-----------------------------------------------------------------------------
* Modification History :

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

    CALL Table.addField("XX<CHARGE.NAME",T24_String,"","")
    CALL Table.addOptionsField("XX-CALC.TYPE","HIGH_AVERAGE_LOW","","")
    CALL Table.addOptionsField("XX-BALANCE","ABSOLUTE_CREDIT_DEBIT","","")
    CALL Table.addField("XX-XX.SOURCE.BALANCE",T24_String,"","")
    CALL Field.setCheckFile('AC.BALANCE.TYPE')
    CALL Table.addField("XX-CHARGE.CODE",T24_String,"","")
    CALL Field.setCheckFile('FT.COMMISSION.TYPE')
    CALL Table.addOptionsField("XX-APPLIED.CHARGE","FULL_HALF_QUARTER","","")
    CALL Table.addField("XX-XX.RESTRICTION",T24_String,"","")
    CALL Table.addField("XX-THRESHOLD.CHARGE.AMOUNT",T24_Numeric,"","")
    CALL Table.addOptionsField("XX>PARTIAL.FLAG","YES_NO","","")
*----------LOCAL REF FIELD-------------
    CALL Table.addField('XX.LOCAL.REF', T24_String, Field_NoInput,'')
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
