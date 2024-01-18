* @ValidationCode : MjoxMjIxODUzNTQ2OkNwMTI1MjoxNzA0Nzg5OTI2MDI0Om5hemloYXI6LTE6LTE6MDowOmZhbHNlOk4vQTpERVZfMjAxNzEwLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 09 Jan 2024 14:45:26
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : nazihar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_201710.0

********************************************************************************
*Developed by: Muhammad Kamrul Hasan
*Date:22 MAR 2017
*********************************************************************************
SUBROUTINE GB.JBL.E.NOF.ATM.BR.WISE.REC.SUM(Y.RETURN)
*-----------------------------------------------------------------------------
* Modification History :
* 1)
* Date :31/12/2023
* Modification Description : RETROFIT from TAFC to TAFJ
* Modified By : MD Shibli Mollah - NITSL
*-----------------------------------------------------------------------------
* Subroutine Description: *THIS ROUTINE IS WRITTEN FOR COUNTING BRANCH WISE ATM CARD REQUEST
*                          AND STATUS (PENDING, APPROVED, DONE)
* Subroutine Type: NOFILE
* Attached To    : NOFILE.JBL.SS.ATM.BR.WISE.REC.SUM
* Attached As    : NOF ENQUIRY ROUTINE
* TAFC Routine Name : ATM.BR.WISE.REC.SUM - R09
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.EB.JBL.ATM.CARD.MGT
* $INSERT GLOBUS.BP I_F.COMPANY
    $USING ST.CompanyCreation
    $USING EB.Reports
    $USING EB.DataAccess

*******--------------------------TRACER------------------------------------------------------------------------------
    WriteData = "GB.JBL.E.NOF.ATM.BR.WISE.REC.SUM Routine is found Successfully"
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

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS

INIT:
    !    F.COMPANY="F.COMPANY"
    F.ATM.CARD.MGT = "F.EB.JBL.ATM.CARD.MGT"
    F.PATH = ""
    Y.CO.CODE = ""
    Y.COMPANY.ENQ = ""
    
    LOCATE "COMPANY.CODE" IN EB.Reports.getEnqSelection()<2,1> SETTING COMP.POS THEN
        Y.COMPANY.ENQ = EB.Reports.getEnqSelection()<4, COMP.POS>
    END

    SEL.LIST = ""
    NO.OF.REC = ""
    Y.ERR = ""
    Y.ID = ""
    R.ATM = ""
    SEL.LIST.ATM = ""
    Y.CO.NAME = ""
    Y.CO.CODE.ARR = ""
    Y.CO.CODE.ARRN = ""
    Y.COUNTS.CO = ""
    Y.STATUS = ""
    Y.PENDING = ""
    Y.APPROVED = ""
    Y.DONE = ""
RETURN

OPENFILES:
    EB.DataAccess.Opf(F.ATM.CARD.MGT, F.PATH)
RETURN

PROCESS:
    IF  Y.COMPANY.ENQ EQ "" THEN
        SEL.CMD = "SELECT ":F.ATM.CARD.MGT
    END
    ELSE
        SEL.CMD = "SELECT ":F.ATM.CARD.MGT : " WITH CO.CODE EQ " : Y.COMPANY.ENQ
    END

    EB.DataAccess.Readlist(SEL.CMD, SEL.LIST, "", NO.OF.REC, Y.ERR)

    LOOP
        REMOVE Y.ID FROM SEL.LIST SETTING POS
    WHILE Y.ID:POS

        EB.DataAccess.FRead(F.ATM.CARD.MGT,Y.ID,R.ATM,F.PATH,Y.ERR)

        Y.STATUS = R.ATM<EB.ATM19.CARD.STATUS>

        IF Y.CO.CODE.ARR = "" THEN
            Y.CO.CODE.ARR = R.ATM<EB.ATM19.CO.CODE>:SUBSTRINGS(Y.STATUS,1,2)
        END ELSE
            Y.CO.CODE.ARR = Y.CO.CODE.ARR:@FM:R.ATM<EB.ATM19.CO.CODE>:SUBSTRINGS(Y.STATUS,1,2)
        END

        Y.COUNTS.CO = COUNT(Y.CO.CODE.ARRN, R.ATM<EB.ATM19.CO.CODE>)
        IF Y.COUNTS.CO EQ 0 THEN
            IF Y.CO.CODE.ARRN NE "" THEN
                Y.CO.CODE.ARRN = Y.CO.CODE.ARRN:@FM:R.ATM<EB.ATM19.CO.CODE>

            END ELSE
                Y.CO.CODE.ARRN = R.ATM<EB.ATM19.CO.CODE>
            END
        END

    REPEAT

    LOOP
        REMOVE Y.ID FROM Y.CO.CODE.ARRN SETTING POS
    WHILE Y.ID:POS

        Y.PENDING = COUNT(Y.CO.CODE.ARR,Y.ID:"PE")
        Y.APPROVED = COUNT(Y.CO.CODE.ARR,Y.ID:"AP")
        Y.DONE = COUNT(Y.CO.CODE.ARR,Y.ID:"DO")
        Y.DENIED = COUNT(Y.CO.CODE.ARR,Y.ID:"DE")
        NO.OF.REC = Y.PENDING + Y.APPROVED + Y.DONE + Y.DENIED
        !CRT Y.ID:"    ":NO.OF.REC:"   ":Y.PENDING:"      ":Y.APPROVED:"        ":Y.DONE :"      ":Y.DENIED
        Y.RETURN<-1>= Y.ID:"|":NO.OF.REC: "|":Y.PENDING:"|":Y.APPROVED:"|":Y.DONE :"|":Y.DENIED
    REPEAT
    Y.RETURN = SORT(Y.RETURN)
RETURN
!Y.RETURN=SORT(Y.RETURN)
END

