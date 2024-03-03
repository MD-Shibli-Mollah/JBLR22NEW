* @ValidationCode : MjotNDA2NjQ4ODY6Q3AxMjUyOjE2NjE1OTc4MTkyMTk6bmF6aWI6LTE6LTE6MDowOnRydWU6Ti9BOlIyMV9TUDkuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 27 Aug 2022 16:56:59
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : nazib
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R21_SP9.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
*-----------------------------------------------------------------------------
* <Rating>-7</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE JBL.H.MUL.PRM.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine JBL.H.MUL.PRM.FIELDS
*
*Retrofitted By:
*    Date         : 24/08/2022
*    Developed By : Md. Nazibul Islam (Peal)
*    Designation  : Software Engineer
*    Email        : nazibul.ntl@nazihargroup.com
*    Attached To  :
*
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("TRH.ID", T24_String) ;* Define Table id
*-----------------------------------------------------------------------------
*    CALL Table.addField(fieldName, fieldType, args, neighbour) ;* Add a new fields
*    CALL Field.setCheckFile(fileName)        ;* Use DEFAULT.ENRICH from SS or just field 1
*    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field
*    CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour) ;* Specify Lookup values
*    CALL Field.setDefault(defaultValue) ;* Assign default value
    CALL Table.addFieldDefinition("SUS.CATEG", "5", "", "")
    CALL Field.setCheckFile("CATEGORY")
    CALL Table.addFieldDefinition("XX.OVERDRAFT.RES.CATEG", "5", "", "")
    CALL Field.setCheckFile("CATEGORY")
    CALL Table.addFieldDefinition("ORDERING.BANK", "15", "ANY", "")
    CALL Table.addFieldDefinition("PROFIT.CENTRE.DEPT", "15", "ANY", "")
    CALL Table.addFieldDefinition("TRN.START.TIME", "5", "T", "")
    CALL Table.addFieldDefinition("TRN.END.TIME", "5", "T", "")
    CALL Table.addFieldDefinition("COMPANY.CODE", "10", "ANY", "")
    CALL Field.setCheckFile("COMPANY")
    CALL Table.addFieldDefinition("XX.LIMIT.CHK.CATEG", "5", "", "")
    CALL Field.setCheckFile("CATEGORY")
*-----------------------------LOCAL REF FIELD---------------------------------
    CALL Table.addField('XX.LOCAL.REF', "ANY", Field_NoInput,'')
*--------------------------------RESERVED-------------------------------------
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
