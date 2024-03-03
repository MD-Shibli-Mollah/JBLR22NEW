* @ValidationCode : Mjo0OTc2NjQ2NTg6Q3AxMjUyOjE2NjA3MTE2NjAwOTk6bmF6aWI6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfU1A5LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 17 Aug 2022 10:47:40
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

SUBROUTINE EB.JBL.MICR.STOCK.MGT.ID
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING AA.Framework
    $USING EB.SystemTables
*-----------------------------------------------------------------------------
* TODO Add logic to validate the id
* TODO Create an EB.ERROR record if you are creating a new error code
*-----------------------------------------------------------------------------
    Y.ID.CHK= EB.SystemTables.getIdNew()
    IF Y.ID.CHK NE 'SYSTEM' THEN
        EB.SystemTables.setE("ID MUST BE SYSTEM")
    END
RETURN
END
*-------------------------------------------------------


*** </region>
*** <region name= Main section>
*** <desc>Main control logic in the sub-routine</desc>

*    GOSUB INITIALISE
*    GOSUB PROCESS
*
*RETURN
*
*
**** </region>
*
**** <region name= INITIALISE>
**** <desc>Initialise local variables and file variables</desc>
*
*INITIALISE:
*
*    F.AA.ARRANGEMENT = ''
*    R.AA.ARRANGEMENT = ''
*    ERR.AA.ARRANGEMENT = ''
*
*RETURN
*
**** </region>
*
**** <region name = PROCESS>
**** <desc>Desired Validation Execution Based upon stage</desc>
*
*PROCESS:
*
*
*    tmp.ID.NEW = EB.SystemTables.getIdNew()
*    R.AA.ARRANGEMENT = AA.Framework.Arrangement.Read(tmp.ID.NEW, ERR.AA.ARRANGEMENT)
*    EB.SystemTables.setIdNew(tmp.ID.NEW)
*
*    IF NOT(R.AA.ARRANGEMENT) AND ERR.AA.ARRANGEMENT THEN
*        EB.SystemTables.setE('CL-INVALID.AA.ID')
*    END
*
*RETURN
*
**** </region>
*END


