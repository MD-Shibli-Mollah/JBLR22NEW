* @ValidationCode : MjotMTI4NjI0OTc3NzpDcDEyNTI6MTY2MTMyNTg1MzA4OTpuYXppYjotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9TUDkuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 Aug 2022 13:24:13
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : nazib
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_SP9.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
SUBROUTINE JBL.H.MUL.PRM.ID
*-----------------------------------------------------------------------------
    !** FIELD definitions FOR JBL.H.MUL.PRM
*!
*
*Retrofitted By:
*    Date         : 24/08/2022
*    Developed By : Md. Nazibul Islam (Peal)
*    Designation  : Software Engineer
*    Email        : nazibul.ntl@nazihargroup.com
*    Attached To  :
*
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING EB.SystemTables
*-----------------------------------------------------------------------------
* TODO Add logic to validate the id
* TODO Create an EB.ERROR record if you are creating a new error code
*-----------------------------------------------------------------------------
    Y.ID.CHK= EB.SystemTables.getIdNew()
    IF Y.ID.CHK NE 'SYSTEM' THEN
        EB.SystemTables.setE("ID MUST BE SYSTEM")
        RETURN
    END
RETURN
END
