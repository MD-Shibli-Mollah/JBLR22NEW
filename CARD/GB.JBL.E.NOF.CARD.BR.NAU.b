* @ValidationCode : MjoxMDA1ODU2MzcwOkNwMTI1MjoxNzA0Nzc3ODkwODE0Om5hemloYXI6LTE6LTE6MDowOmZhbHNlOk4vQTpERVZfMjAxNzEwLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 09 Jan 2024 11:24:50
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : nazihar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_201710.0

SUBROUTINE GB.JBL.E.NOF.CARD.BR.NAU(Y.RETURN)

* Modification History :
* 1) *List of Closed deposit accounts for given period
* Date :31/12/2023
* Modification Description : RETROFIT from TAFC to TAFJ
* Modified By : MD Shibli Mollah - NITSL
*-----------------------------------------------------------------------------
* Subroutine Description: This routine is used for returning FT Record Id's.
* Subroutine Type: NOFILE
* Attached To    : NOFILE.JBL.SS.CARD.BR.NAU
* Attached As    : NOF ENQUIRY ROUTINE
* TAFC Routine Name : CARD.BR.NAU - R09
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
* $INSERT GLOBUS.BP I_F.ACCOUNT
    $USING AC.AccountOpening
* $INSERT GLOBUS.BP I_F.FUNDS.TRANSFER
    $USING FT.Contract
* $INSERT BP I_F.ATM.CARD.MGT
    $INSERT I_F.EB.JBL.ATM.CARD.MGT
    $USING CQ.Cards
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.TransactionControl
    $USING EB.Interface
    $USING EB.Reports

*******--------------------------TRACER------------------------------------------------------------------------------
    WriteData = "GB.JBL.E.NOF.CARD.BR.NAU Routine is found Successfully"
    FileName = 'SHIBLI_ATM.txt'
    FilePath = 'D:/Temenos/t24home/default/DL.BP'
    OPENSEQ FilePath,FileName TO FileOutput THEN NULL
    ELSE
        CREATE FileOutput ELSE
        END
    END
    WRITESEQ WriteData APPEND TO FileOutput ELSE
        CLOSESEQ FileOutput
    END
    CLOSESEQ FileOutput
*******--------------------------TRACER-END--------------------------------------------------------*********************

    FN.ATM = "F.EB.JBL.ATM.CARD.MGT$NAU"
    F.ATM = ""
    FN.FT.NAU = "F.FUNDS.TRANSFER$NAU"
    F.FT.NAU = ""
    FN.FT = "F.FUNDS.TRANSFER"
    F.FT = ""
    FN.FT.HIS = "F.FUNDS.TRANSFER$HIS"
    F.FT.HIS = ""

    Y.ID.COMPANY = EB.SystemTables.getIdCompany()

    LOCATE "ACCT.NO" IN EB.Reports.getEnqSelection()<2,1> SETTING ACCT.POS THEN
        Y.ACCT = EB.Reports.getEnqSelection()<4,ACCT.POS>
    END
    LOCATE "REF.NO" IN EB.Reports.getEnqSelection()<2,1> SETTING REF.POS THEN
        Y.REF = EB.Reports.getEnqSelection()<4,REF.POS>
    END

    EB.DataAccess.Opf(FN.ATM,F.ATM)
    EB.DataAccess.Opf(FN.FT.NAU,F.FT.NAU)
    EB.DataAccess.Opf(FN.FT,F.FT)
    EB.DataAccess.Opf(FN.FT.HIS,F.FT.HIS)

    SEL.CMD = "SELECT ":FN.ATM:" WITH CARD.STATUS EQ PENDING AND RECORD.STATUS EQ INAU AND ISSUE.WAIVE.CHARGE EQ 'NO' AND CO.CODE EQ ": Y.ID.COMPANY
    IF Y.ACCT NE "" THEN
        SEL.CMD = SEL.CMD :" AND ACCT.NO EQ " : Y.ACCT
    END
    
    IF Y.REF NE "" THEN
        SEL.CMD = SEL.CMD :" AND @ID EQ " : Y.REF
    END
    
    EB.DataAccess.Readlist(SEL.CMD,SEL.LIST,"",NO.OF.RECORD,RET.CODE)

    LOOP
        REMOVE Y.REC.ID FROM SEL.LIST SETTING Y.POS
    WHILE Y.REC.ID:Y.POS
        EB.DataAccess.FRead(FN.ATM,Y.REC.ID,R.ATM.REC,F.ATM,Y.ERR)
        Y.REQUEST.TYPE = R.ATM.REC<EB.ATM19.REQUEST.TYPE>
        Y.REISSUE.REASON = R.ATM.REC<EB.ATM19.REISSUE.REASON>

        IF Y.REQUEST.TYPE EQ "REISSUE" AND Y.REISSUE.REASON EQ 5 THEN

        END

        ELSE IF Y.REQUEST.TYPE EQ "PINREISSUE" AND Y.REISSUE.REASON EQ 7 THEN

        END

        ELSE IF R.ATM.REC<EB.ATM19.ATTRIBUTE5> NE "" THEN
            Y.FT.ID = R.ATM.REC<EB.ATM19.ATTRIBUTE5>

            EB.DataAccess.FRead(FN.FT.NAU,Y.FT.ID,R.REC.NAU,F.FT.NAU,Y.ERR.FT.NAU)

            EB.DataAccess.FRead(FN.FT,Y.FT.ID,R.REC.LIVE,F.FT,Y.ERR.FT)

            EB.DataAccess.ReadHistoryRec(F.FT.HIS,Y.FT.ID,R.REC.HIS,Y.ERR.FT.HIS)

            Y.RECORD.STATUS = R.REC.HIS<FT.Contract.FundsTransfer.RecordStatus>
            IF R.REC.NAU EQ "" AND R.REC.LIVE EQ "" AND (R.REC.HIS EQ "" OR Y.RECORD.STATUS EQ 'REVE') THEN
                Y.RETURN<-1>= Y.REC.ID
            END
        END
        ELSE
            Y.RETURN<-1>= Y.REC.ID
        END

    REPEAT
    CRT Y.RETURN
RETURN
END

