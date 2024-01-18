SUBROUTINE CR.JBL.ODINT.UPDATE
*-----------------------------------------------------------------------------
*
*Subroutine Description: Interest on OD Rate Update same as Principal Interest Rate
*Subroutine Type       :
*Attached To           : ACTIVITY.API(JBL.ACCT.TITLE.API)
*Attached As           : Pre Validation Routine
*Developed by          : #-Mehedi-#
*Incoming Parameters   :
*Outgoing Parameters   :
*-----------------------------------------------------------------------------
*** <region name= Arguments>
*** <desc>To define the arguments </desc>
* Incoming Arguments:
*
* Outgoing Arguments:
*
*** </region>
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_AA.APP.COMMON
    $INSERT I_AA.LOCAL.COMMON
*
    $USING EB.SystemTables
    $USING AA.Framework
    $USING EB.DataAccess
    $USING ST.Customer
    $USING EB.Updates
    $USING AA.Interest
    $USING EB.API
*
    GOSUB PROCESS
RETURN
*-------
PROCESS:
*-------
    ArrangementId = c_aalocArrActivityRec<AA.Framework.ArrangementActivity.ArrActArrangement>
    PROP.CLASS.TRM = 'INTEREST'
    AA.Framework.GetArrangementConditions(ArrangementId,PROP.CLASS.TRM,'PRINCIPALINT','',RETURN.IDS.TRM,RETURN.VALUES.TRM,ERR.MSG.TRM)
    RETURN.VALUES.TRM = RAISE(RETURN.VALUES.TRM)
    Y.PR.INT.RT = RETURN.VALUES.TRM<AA.Interest.Interest.IntFixedRate>
    EB.SystemTables.setRNew(AA.Interest.Interest.IntFixedRate,Y.PR.INT.RT)
    
    Y.DATA = 'Trigger,':Y.PR.INT.RT
    Y.DIR = 'WRITE.CHK'
    Y.FILE.NAME = 'PRINT.RATE.txt'
*    OPENSEQ Y.DIR,Y.FILE.NAME TO F.DIR THEN NULL
*    WRITESEQ Y.DATA APPEND TO F.DIR ELSE
*        CRT "Unable to write"
*        CLOSESEQ F.DIR
*    END
RETURN
END
